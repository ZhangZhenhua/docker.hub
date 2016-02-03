#!/bin/bash

touch /var/log/salt/master
/etc/init.d/salt-master start
tail -f /var/log/salt/master
