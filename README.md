nanohttp
========

small Webserver written in Perl

## Features

- easy to install, configure and understand
- small footprint
- can run under a different user/group (default is nobody/nobody)
- easily program dynamic web pages with perl

## Installation

- Get the latest archiv from the download page.
- Extract all files to a directory of your choice.
- You can edit some configuration variables if you want. To do so, open the file nanohttp.pl in your favorite editor. You will see some configuration data on top of the file. The most interesting are surely the $SERVER_PORT and the hash-array %hMimeTypes. The default for the $SERVER_PORT is 3000, but remember, you must be root to start the server on a port smaller than 1024.
- Now it is time to start the server. Open a console, change to the directory, where you extracted all the files from the archiv. If you type "ls" now, you should see something like "html lib nanohttp.pl". Now you can start the server by typing "./nanohttp.pl". If all goes well you will see the lines
Starting http-Server
```
Listening for requests on port 3000 
or the portnumber you changed $SERVER_PORT to. 
```
May be you see the error message
```
Starting http-Server
Could not listen to port 80 : Address already in use at ./nanohttp.pl
```
If so make sure, there is no other programm running that uses this port. This counld be an other http-server or a also a proxy.
- To test the nanoHttp web server open a web browser and go to the url
```
    http://localhost:3000/
```
- Then your browser should load a copy of the nanoHttp web site, sice this is the default installation.
