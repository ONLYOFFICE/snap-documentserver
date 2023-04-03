#!/bin/bash

umask 0066

export RABBITMQ_MNESIA_BASE="$SNAP_DATA/var/lib/rabbitmq/mnesia"
export RABBITMQ_LOG_BASE="$SNAP_DATA/var/log/rabbitmq"
export RABBITMQ_GENERATED_CONFIG_DIR="$SNAP_DATA/var/lib/rabbitmq/config"
export RABBITMQ_SCHEMA_DIR="$SNAP_DATA/var/lib/rabbitmq/schema"
export RABBITMQ_CONF_ENV_FILE="$SNAP/rabbitmq-env.conf"

. `dirname $0`/rabbitmq-env