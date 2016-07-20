#!/bin/sh

PERIOD=120
R=`date +%s`

if [ -z $TIMER ]; then
    NSECONDS=$((R % PERIOD))
else
    NSECONDS=$TIMER
fi

pid=$$
LOG="/tmp/timerprint-$NSECONDS-$pid.log"
touch $LOG

mkdir $LOGDIR/$APP_KIND

ii=0
for i in `seq 1 $NSECONDS`
do
    echo $NSECONDS $ii >> $LOG
    sleep 1
    ii=$((ii+1))
done
