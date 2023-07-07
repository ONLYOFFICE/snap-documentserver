#!/bin/bash

TOOLS_DIR=$SNAP_DATA/var/www/onlyoffice/documentserver/server/tools
PLUGIN_MANAGER=$TOOLS_DIR/pluginsmanager
PLUGIN_DIR=$SNAP_DATA/var/www/onlyoffice/documentserver/sdkjs-plugins
SNAP_DS_DIR=$SNAP/var/www/onlyoffice/documentserver

if [ ! -d $PLUGIN_DIR ]; then
  mkdir -p $PLUGIN_DIR
  cp -R $SNAP_DS_DIR/sdkjs-plugins $PLUGIN_DIR/..
fi

if [ ! -d $TOOLS_DIR ]; then
  mkdir -p $TOOLS_DIR
  cp $SNAP_DS_DIR/server/tools/pluginsmanager $TOOLS_DIR
  cp $SNAP_DS_DIR/server/FileConverter/bin/*.so* $TOOLS_DIR
fi

"${PLUGIN_MANAGER}" --directory=\"${PLUGIN_DIR}/\" --update=\"${PLUGIN_DIR}/plugin-list-default.json\"
