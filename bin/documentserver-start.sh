#!/bin/bash

mkdir -p $SNAP_DATA/var/log/supervisor/
mkdir -p $SNAP_DATA/var/run/
touch $SNAP_DATA/var/log/supervisor/supervisord.log
touch $SNAP_DATA/var/run/supervisord.pid

mkdir -p $SNAP_DATA/var/log/onlyoffice/documentserver/docservice/
mkdir -p $SNAP_DATA/var/log/onlyoffice/documentserver/converter/
mkdir -p $SNAP_DATA/var/log/onlyoffice/documentserver/gc/
mkdir -p $SNAP_DATA/var/log/onlyoffice/documentserver/metrics/
mkdir -p $SNAP_DATA/var/log/onlyoffice/documentserver/spellchecker/
mkdir -p $SNAP_DATA/var/log/onlyoffice/documentserver-example/

touch $SNAP_DATA/var/log/onlyoffice/documentserver/docservice/out.log
touch $SNAP_DATA/var/log/onlyoffice/documentserver/docservice/err.log
touch $SNAP_DATA/var/log/onlyoffice/documentserver/converter/out.log
touch $SNAP_DATA/var/log/onlyoffice/documentserver/converter/err.log
touch $SNAP_DATA/var/log/onlyoffice/documentserver/gc/out.log
touch $SNAP_DATA/var/log/onlyoffice/documentserver/gc/err.log
touch $SNAP_DATA/var/log/onlyoffice/documentserver/metrics/out.log
touch $SNAP_DATA/var/log/onlyoffice/documentserver/metrics/err.log
touch $SNAP_DATA/var/log/onlyoffice/documentserver/spellchecker/out.log
touch $SNAP_DATA/var/log/onlyoffice/documentserver/spellchecker/err.log
touch $SNAP_DATA/var/log/onlyoffice/documentserver-example/out.log
touch $SNAP_DATA/var/log/onlyoffice/documentserver-example/err.log

cp $SNAP_DATA/etc/nginx/sites-available/onlyoffice-documentserver $SNAP_DATA/etc/nginx/sites-enabled

LD_LIBRARY_PATH=$SNAP_DATA/bin \
NODE_ENV=production-linux \
NODE_CONFIG_DIR=$SNAP_DATA/server/Common/config \
node --max_old_space_size=4096 $SNAP_DATA/server/FileConverter/sources/convertermaster.js

NODE_ENV=production-linux \
NODE_CONFIG_DIR=$SNAP_DATA/server/Common/config \
node $SNAP_DATA/server/SpellChecker/sources/server.js

NODE_ENV=production-linux \
NODE_CONFIG_DIR=$SNAP_DATA/server/Common/config \
node --max_old_space_size=4096 $SNAP_DATA/server/DocService/sources/server.js

