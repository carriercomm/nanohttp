#!/usr/bin/perl -T

# nanoHttp 0.1
# oliver@kurmis.com
use IO::Socket::INET;
print "Starting http-Server nanoHttp\n";

$INC[@INC] = "lib";
require "core.pl";

# Open Socket
my $server = IO::Socket::INET->new(
    LocalPort => $SERVER_PORT,
    Proto     => 'tcp',
    Listen    => SOMAXCONN
  )
  or die "Could not listen to port $SERVER_PORT : $!";

print "Listening for requests on port $SERVER_PORT\n";

# safe current output filehandel
# so we can inform the user about warnings
# after selecting the logfile as standard
# output filehandel
$CONSOLE=select;

if ($USE_LOGFILE) {
	# logfile, all messages goes here
	open LOG, ">$LOGFILE" or die "logfile: $!";
	open STDERR, ">>&LOG";
	select LOG;
	## disable buffering
	$| = 1;
	print $CONSOLE "Using logfile $LOGFILE\n";
} else {
	print $CONSOLE "Not using a logfile\n";
}

if ( $CHANGE_USER ) {
	# changing user and group is not available under windows
	unless ( $^O =~ /MSWin32/ ) {
	    # resolve user an group names to numeric ids
	    my $uid = getpwnam($RUNAS_USER);
	    my $gid = getgrnam($RUNAS_GROUP);
	
	    $) = "$gid $gid" if $gid;
	    $> = $uid if $uid;
	    print $CONSOLE "Running as user $RUNAS_USER and group $RUNAS_GROUP \n";
	}
}

if ( !$> ) {
	print $CONSOLE "
		WARNING: running as user (uid $>)
		Never run as root on a productive system!\n\n"
} 

if ($RUN_AS_DAEMON) {
	# first become Daemon , if not running under windows
	unless ( $^O =~ /MSWin32/ ) {
		print $CONSOLE "Running as daemon\n";
	    my $ppid = fork;
	    exit if $ppid;
	    die "fork: $!" unless defined $ppid;
	}
} else {
	print $CONSOLE "Running as foreground process\n";
}


# father has nothing to do if chield process is finished
$SIG{CHLD} = 'IGNORE';

## main loop
while (1) {

    # wait for a connection
    die "Error in accept: $!"
      unless defined( my $client = $server->accept() );
	if ($RUN_MULI_INSTANCES) {
	    # create a chield process to serve the connection
	    my $pid = fork;
	    die "fork: $!" unless defined $pid;
	
	    if ($pid) {
	        # father does not need the client socket, so close it
	        close $client;
	    } else {
	        # chield does not need the master socket, so close it
	        close $server;
	        
	        # get the server answer from the function that handles the protokoll
	        # and print it to the client connection
		    print $client http($client);
		    # no close the chield process
	        exit;
	    }
	} else {
		print $client http($client);
	}
}
