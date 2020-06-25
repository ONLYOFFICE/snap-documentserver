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

mkdir -p $SNAP/etc/nginx/sites-enabled
ln -s $SNAP/etc/nginx/sites-available/onlyoffice-documentserver $SNAP/etc/nginx/sites-enabled/onlyoffice-documentserver

$SNAP/usr/bin/python $SNAP/usr/bin/supervisord -n -c $SNAP_DATA/etc/supervisor/supervisord.conf
