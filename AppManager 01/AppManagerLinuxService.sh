#!/bin/bash
#
# Startup script for the AppManager
#
# chkconfig: 345 99 02
#
# description: Run the Applications Manager  program

INITLOG_ARGS=""

prog="AppManager"

progname="ManageEngine Applications Manager"

RETVAL=0

# Edit the following to indicate the 'APPMANAGER_HOME' directory for your installation

MDIR=/home/test/ManageEngine/AppManager15

if [ ! -d "$MDIR" ]

then

 echo "Invalid directory $MDIR"

    exit 1

fi

start()
{

       cd $MDIR
       sh shutdownApplicationsManager.sh -force
       if [ -d "/var/log/AppManager" ] 
       then
         echo "Directory /var/log/AppManager exists." 
         mv -f /var/log/AppManager/AppManager.log /var/log/AppManager/AppManager1.log
       else
         mkdir /var/log/AppManager
       fi

       #mv -f /var/log/AppManager/AppManager.log /var/log/AppManager/AppManager1.log

       echo "Starting $progname"
       cd $MDIR 

       nohup sh startApplicationsManager.sh >/var/log/AppManager/AppManager.log 2>&1 &
	
	
       RETVAL=$?

       echo

       [ $RETVAL = 0 ] && touch /home/test/ManageEngine/AppManager15

}

stop()
{

        echo "Stopping $progname"

        cd $MDIR

        sh shutdownApplicationsManager.sh >>/var/log/AppManager/AppManager.log 2>&1
	

	sleep 10
	
	sh shutdownApplicationsManager.sh -force>>/var/log/AppManager/AppManager.log 2>&1
	
}

case "$1" in

 start)

       start

         ;;

 stop)
      stop

        ;;

    *)

     echo "Usage: $prog {start|stop}"

     exit 1

     ;;

esac
exit $RETVAL