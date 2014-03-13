# config file for the nanoHttp webserver

# the port the server should listen to
# standard port for http is 80
# but server has to be startet from user root to listen on a portnumber < 1024
# you can change this to port 8080 or so if you have no root access
# but for productive use it is recommanded to use port 80 since this is the web
# standard
$SERVER_PORT 	  = 8080;

$CHANGE_USER       = 1;
$RUNAS_USER  	  = "root";
$RUNAS_GROUP 	  = "nobody";

# directory that holds the webfiles

# default = html
$HTML_DIR    	  = "html";
$HTML_ERROR_DIR	= $HTML_DIR."/error";
$HTML_LIB_DIR	  = $HTML_DIR."/lib";
$HTML_INDEX_FILE   = "index.html";

$DEFAULT_CONTENT_TYPE = "text/plain";

# starts the server as a deamon instead of a foreground process
# if set to 1 $USE_LOGFILE should be set to 1 too
# default = 1
$RUN_AS_DAEMON     = 1;

# allows the server to start a master process that
# starts a chield process for every clien request
# This allows to serve more than one client-request
# at the same time
# recommended setting is 1
# default = 1
$RUN_MULI_INSTANCES= 1;

# 
# default = 1
$USE_LOGFILE 	  = 1;

$EXTENDED_LOGGING  = 0;
$LOG_DIR     	  = "log";
$LOGFILE     	  = $LOG_DIR."/nanohttp.log";

1;
