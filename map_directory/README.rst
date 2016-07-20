timerprint
==========

This is just a very simple docker image for testing. It will write one log entry
to /tmp/timerprint-$NSECONDS-$PID.log every second for a time period of $NSECONDS
seconds. The $NSECONDS is chosen randomly between 0-120.

BUILD
_____

::

    sudo docker build -t timerprint:latest .

Run
___

::

    docker run -it -v /tmp:/tmp timerprint:latest

