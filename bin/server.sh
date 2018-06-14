#!/bin/sh
# to run master server path/server.sh master
# to run client server: path/server.sh 
## generate config file
cd /opt/cronicle/conf


SERVER_TYPE=$(env  | grep SERVER_TYPE | grep -oe '[^=]*$') || {
  echo "Environment variable 'SERVER_TYPE' not set. Possible values: ['master', 'slave']" ;
  echo "Exiting.."
  exit 1;
} 
echo "SERVER_TYPE: " $SERVER_TYPE
dockerize -template config.tmpl.json:config.json echo 'config.json saved.'

cd /opt/cronicle/bin

if [ $SERVER_TYPE = "master" ]
then
  echo  "Setting up this server as master";
  ./control.sh setup;
  ./debug.sh --master
else
  echo  "Setting up this server as slave";
  ./debug.sh 
fi
