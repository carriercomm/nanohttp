nanoHttp
========

nanoHttp is a small Webserver written in Perl.

Homepage and demo: http://railsbox-30514.euw1.nitrousbox.com


## Features

- easy to install, configure and understand
- small footprint
- can run under a different user/group (default is nobody/nobody)
- supports dynamic web pages with perl

## Installation

- Get the latest archiv from the download page.
- Extract all files to a directory of your choice.
- You can edit some configuration variables if you want. To do so, open the file lib/conf.pl in your favorite editor. You will see some configuration data on top of the file. First the most important is the $SERVER_PORT. The default for the $SERVER_PORT is 3000. You must be root to start the server listening on a port smaller than 1024.
- Now it is time to start the server. Open a console, change to the directory, where you extracted all the files from the archive. If you type "ls" now, you should see something like "html lib log nanohttp.pl". Now you can start the server by typing "./nanohttp.pl". If everything is okay you will see the lines

```
Starting http-Server nanoHttp                                                                                                                                                                                                       
Listening for requests on port 3000                                                                                                                                                                                                 
Using logfile log/nanohttp.log                                                                                                                                                                                                      
Running as user nobody and group nobody                                                                                                                                                                                             
Running as daemon  
```
May be you see an error message like this:
```
Starting http-Server nanoHttp                                                                                                                                                                                                       
Could not listen to port 3000 : Address already in use at ./nanohttp.pl line 12. 
```
In this case please make sure, that there is no other programm running that uses this port. This counld be an other http-server or a proxy.
- To test the nanoHttp web server open a web browser and go to the url
```
    http://localhost:3000/
```
- Then your browser should load a copy of the nanoHttp web site, because it is included in the default installation.
