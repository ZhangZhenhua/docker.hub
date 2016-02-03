#!/bin/bash

touch /var/log/salt/minion
/etc/init.d/salt-minion start
tail -f /var/log/salt/minion
