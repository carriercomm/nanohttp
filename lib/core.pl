require "conf.pl";
require "mimetypes.pl";

# init days and months for http_date
@weekday = ( "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" );
@month = ( "Jan", "Feb", "Mar", "Apr", "May", "Jun",
	   "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" );


sub http_date {
	local @tm = gmtime($_[0]);
	return sprintf "%s, %d %s %d %2.2d:%2.2d:%2.2d GMT",
		$weekday[$tm[6]], $tm[3], $month[$tm[4]], $tm[5]+1900,
		$tm[2], $tm[1], $tm[0];
}

sub log_date {
	local @tm = gmtime($_[0]);
	return sprintf "[%d/%d/%d:%2.2d:%2.2d:%2.2d +0000]",
		$tm[3], $tm[4], $tm[5]+1900,
		$tm[2], $tm[1], $tm[0];
}

# add your lib path to the perl include paths
$INC[@INC] = $HTML_LIB_DIR;

sub parseFile {
	# gets two references as parameters
	# contains the parsed file
    my $pRet = shift;
    # error messages are appende here
    # if an error occurs an ISE 500 is thrown
    my $pERR = shift;

	$saveFH=select; 					  	    # save the current filehandel for output 
    ${$pRet} =~ s|<%(.*?)%>| 					# get the code from inside the tokens
    		local $::OUT_BUFFER = "";			#reset the output buffer fo this snippet
    		open(BUFFER,'>', \$::OUT_BUFFER)    # BUFFER is a in memory files 
    			or die "Can't open BUFFER: $!";
    		select BUFFER; 					    # all print commands shell write to BUFFER 
    		eval $1;							# execute the code snippet
    		${$pERR}.=$@;						# append error messages  
    		close BUFFER;						# close the in memory file
    		$::OUT_BUFFER						# $::OUT_BUFFER now contains the results from the code
    											# snippet and this replaces the tokens and the code betwin
    	|xseg;  ## options for the regexpr substitution: 
    			## extended, single line, eval, global:
    select $saveFH;
	## disable buffering
	$| = 1;
    
}

sub sGetContentType {
	my $sFileName = shift;
	my $sContentType = "";
    my $ext;
    my $type;
    while (($ext,$type) = each(%mimeTypes)) {
    	if ($sFileName =~ /.$ext/i) {
    		$sContentType 	= $type;
    		last;
    	}
    }
    if (!$sContentType) {
        $sContentType = $DEFAULT_CONTENT_TYPE;
    }
	return $sContentType;
}

# the processing of the protokoll
sub http {
    my $sock = shift;
    my $sRequest = <$sock>;
    my %ENV = ();
    (my $REQUEST_METHOD, my $REQUEST_URI, my $REQUEST_PROTOKOLL) = split(/ /,$sRequest);
	$REQUEST_URI =~ s/%20|\+/ /g;
    (my $sFileName, my $REQUEST_PARAMETER_STRING)    = split('\?',$REQUEST_URI);
	if ($REQUEST_PARAMETER_STRING) {
	    foreach (split('&',$REQUEST_PARAMETER_STRING)) {
			(my $parameterName, my $parameterValue) = split('=',$_);
			if ($parameterValue) {
				$ENV{$parameterName} = $parameterValue;
			}
	    }
	}
    if (-d "$HTML_DIR/$sFileName") {
		if (!($sFileName =~ m|/$|)) {
			$sFileName .='/';
		}
        $sFileName .= $HTML_INDEX_FILE;
    }
	my $sReturn  		= "";
    my $sReturnHead 	 = "";
    my $sReturnBody      = "";
	my $iStatusCode      = 200;
	my $sStatus          = "";
    my $sContentType     = $DEFAULT_CONTENT_TYPE;
	my $sExt             = "";
    my $EVAL_ERROR       = "";
    my $EVAL_ERROR_ERROR = "ISE processing ISE page\n";

    ## never return files from the /lib/ directory, you can use this
    ## directory to hold most of your script code, so it is more
    ## unlikely that it is dumped to the world by accident
    ##
    ## never dump perl source from *.pl or *.pm files to the Browser
	if ( !($sFileName =~ m|^/lib/|i) && !($sFileName =~ m|.p[lm]$|i) && open(FH,"$HTML_DIR$sFileName") ) {		
		## for now everything is ok
		## set http-Status
    	$sStatus   = "200 OK";
	} elsif ( open(FH,"$HTML_ERROR_DIR/404.html") ) {
        # the file was not found or is not allowed to be displayed
        ## get 404-error page 
        $iStatusCode      = 400;
    	$sStatus = "$iStatusCode Not Found";
        $sFileName = "404.html";
    }
    
    if (!$sStatus){
    	## the error page for the 404 error could not be found too
    	$iStatusCode      = 400;
    	$sStatus = "$iStatusCode Not Found";
    	$sReturn = "Error: file not found ($HTML_DIR$sFileName)";
	} else {
		$sContentType = sGetContentType($sFileName);
		## read the file line by line 
		while (<FH>) {
			$sReturn .= $_;
		}
		close(FH);
    }

    if ( !($sContentType =~ m|^image|) && !($sContentType =~ m|^application|)&& !($sContentType =~ m|^audio|)) {
        parseFile(\$sReturn,\$EVAL_ERROR);
    }
    if ( $EVAL_ERROR ) {
    	## an internal server error occured
        $sReturn = "";
        $sStatus = "500 Internal Server Error";
        if ( open(FH,"$HTML_ERROR_DIR/500.html") ) {
        	## try go display a error page
            $sFileName = "500.html";
            $sContentType = sGetContentType($sFileName);
		    while (<FH>) {
			     $sReturn .= $_;
		    }
            close(FH);
            $EVAL_ERROR_ERROR = "";
            parseFile(\$sReturn,\$EVAL_ERROR_ERROR);
        }
        print "\$EVAL_ERROR_ERROR=$EVAL_ERROR_ERROR\n";
        if ($EVAL_ERROR_ERROR) {
             $sContentType = $DEFAULT_CONTENT_TYPE;
             $sReturn = "Internal Server Error:\n\n$EVAL_ERROR";
        }
    }
	
	$iAnswerLength = length($sReturn);
    $sReturnHead .= "HTTP/1.1 $sStatus\n";
    $sReturnHead .= "Server: nanoHttp\n";
    $sReturnHead .= "Connection: close\n";
    $sReturnHead .= "Content-Type: $sContentType\n";
    $sReturnHead .= "Content-location: $sFileName\n";
    $sReturnHead .= "Content-Length: $iAnswerLength\n";
    $sReturnHead .= "\n";
    if ($EXTENDED_LOGGING) {
	    print $sRequest.$sReturnHead;
    } else {
    	chomp($sRequest);
    	print $sock->sockhost()." - - ".log_date(time)." \"$sRequest\" $iStatusCode $iAnswerLength\n";
    }
    return $sReturnHead.$sReturn;
}

1;
