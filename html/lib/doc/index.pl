print '
<h1>nanoHttp :: Documentation</h1>

<ul><h3>Installation</h3>
<li>Get the latest archiv from the download page.
<li>Extract all files to a directory of your choice.
<li>You can edit some configuration variables if you want. 
To do so, open the file
nanohttp.pl in your favorite editor. You will see some 
configuration data on top
of the file. The most interesting are surely the 
$SERVER_PORT and the hash-array 
%hMimeTypes. The default for the $SERVER_PORT is 
8080, but remember, you must be
root to start the server on a port smaller than 1024.
<li>Now it is time to start the server. Open a console, 
change to the directory,
where you extracted all the files from the archiv. 
If you type "ls" now, you should see
something like "html lib nanohttp.pl". Now you can 
start the server by typing
"./nanohttp.pl". If all goes well you will see the lines
<pre>
Starting http-Server
Listening for requests on port 8080 
</pre> or the portnumber you changed $SERVER_PORT to.
May be you see the error message
<pre>
Starting http-Server
Could not listen to port 80 : Address already in use at ./nanohttp.pl
</pre>
If so make sure, there is no other programm running that uses this
port. This counld be an other http-server or a also a proxy.
<li> To test the <b>nanoHttp</b> web server open a 
web browser and go to the url<br>
"http://localhost/"<br>Then your browser should 
load a copy of the <b>nanoHttp</b>
web site, sice this is the default installation.
</ul>

<ul><h3>Features</h3>
<li>easy to install, configure and understand
<li>small footprint
<li>can run under a different user/group (default is nobody/nobody)
<li>easily program dynamic web pages with perl
</ul>

<ul><h3>Bugs</h3>
<li>POST variables do not work
<li>If not started by root, the server can only listen on 
ports &gt; 1024.
<li>sent http-header is minimal
<li>and surely more
</ul>

<ul><h3>ToDos</h3>
<li>make most of the docu
<li>working with POST variables
<li>send full http-header
<li>working with WIN32
<li>implement standard log file format
<li>beautify source code
<li>configurable list content-types which should not be parsed,
like binary files (gif,jpg,zip ...)
<li>get <br>print</p> to work
<li>find a Logo
<li>check for security issues
<li>build init scripts, to start the server during boot process
<li>build rpm and deb packages
</ul>

<ul><h3>Changelog</h3>
<li>0.1 2004-03-10 initial Release with
		<ul>
			<li>dynamic web pages with perl
			<li>working with GET-variables
			<li>some Content-Types text, image and archive files
			<li>Error pages for 404 and 500 errors
			<li>some examples
		</ul>
	</dd>
</ul>';