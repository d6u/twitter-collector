#!/bin/bash

cd /root/app
exec node app.js >>/var/log/app.log 2>> /var/log/app-err.log
