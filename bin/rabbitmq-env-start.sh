#!/bin/bash

umask 0066

RABBITMQ_MNESIA_BASE="$SNAP_DATA/var/lib/rabbitmq/mnesia"
RABBITMQ_LOG_BASE="$SNAP_DATA/var/log/rabbitmq"
RABBITMQ_GENERATED_CONFIG_DIR="$SNAP_DATA/var/lib/rabbitmq/config"
RABBITMQ_SCHEMA_DIR="$SNAP_DATA/var/lib/rabbitmq/schema"
RABBITMQ_CONF_ENV_FILE="$SNAP/rabbitmq-env.conf"

. `dirname $0`/rabbitmq-env