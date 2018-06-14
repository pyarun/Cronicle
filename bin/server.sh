#!/bin/sh
# to run master server path/server.sh master
# to run client server: path/server.sh 
## generate config file
cd /opt/cronicle/conf

dockerize -template config.tmpl.json:config.json echo 'config.json saved.'

cd /opt/cronicle/bin

if [ $1 = "master" ]
then
  ./control.sh setup;
  ./debug.sh --master
else
  ./debug.sh 
fi
