#!/bin/bash

CONF_DIR="$SNAP_DATA/etc/onlyoffice/documentserver"
DATA_DIR="$SNAP_DATA/var/www/onlyoffice/Data"
NGINX_ONLYOFFICE_PATH="${CONF_DIR}/nginx"
NGINX_ONLYOFFICE_CONF="${NGINX_ONLYOFFICE_PATH}/ds.conf"
SSL_VERIFY_CLIENT="off"
ONLYOFFICE_HTTPS_HSTS_ENABLED="true"
ONLYOFFICE_HTTPS_HSTS_MAXAGE="31536000"
SSL_CERTIFICATES_DIR="${DATA_DIR}/certs"
SSL_DHPARAM_PATH="$SSL_CERTIFICATES_DIR/dhparam.pem"
SSL_CERTIFICATE_PATH="$SSL_CERTIFICATES_DIR/onlyoffice.crt"
SSL_KEY_PATH="$SSL_CERTIFICATES_DIR/onlyoffice.key"

#check loopback
LOOPBACK_ENABLED=$(snapctl get onlyoffice.loopback)
if [ "${LOOPBACK_ENABLED}" == "true" ]; then
    sed -i -r 's/ #(allow)/ \1/' \
        $NGINX_ONLYOFFICE_PATH/ds.conf.tmpl $NGINX_ONLYOFFICE_PATH/ds-ssl.conf.tmpl
    sed -i -r 's/ #(deny)/ \1/' \
        $NGINX_ONLYOFFICE_PATH/ds.conf.tmpl $NGINX_ONLYOFFICE_PATH/ds-ssl.conf.tmpl
else
    sed -i -r 's/ (allow)/ #\1/' \
        $NGINX_ONLYOFFICE_PATH/ds.conf.tmpl $NGINX_ONLYOFFICE_PATH/ds-ssl.conf.tmpl
    sed -i -r 's/ (deny)/ #\1/' \
        $NGINX_ONLYOFFICE_PATH/ds.conf.tmpl $NGINX_ONLYOFFICE_PATH/ds-ssl.conf.tmpl
fi

mkdir -p $SNAP_DATA/var/log/nginx/
mkdir -p $SNAP_DATA/var/cache/nginx/client_temp
mkdir -p $SNAP_DATA/var/log/onlyoffice/documentserver
touch $SNAP_DATA/var/log/onlyoffice/documentserver/nginx.error.log
touch $SNAP_DATA/var/log/nginx/access.log
touch $SNAP_DATA/var/log/nginx/error.log

update_nginx_settings(){

  # setup HTTPS
  if [ -f "${SSL_CERTIFICATE_PATH}" -a -f "${SSL_KEY_PATH}" ]; then
    cp -f ${NGINX_ONLYOFFICE_PATH}/ds-ssl.conf.tmpl ${NGINX_ONLYOFFICE_CONF}

    # configure nginx
    sed 's,{{SSL_CERTIFICATE_PATH}},'"${SSL_CERTIFICATE_PATH}"',' -i ${NGINX_ONLYOFFICE_CONF}
    sed 's,{{SSL_KEY_PATH}},'"${SSL_KEY_PATH}"',' -i ${NGINX_ONLYOFFICE_CONF}

    # turn on http2
    sed 's,\(443 ssl\),\1 http2,' -i ${NGINX_ONLYOFFICE_CONF}

    # if dhparam path is valid, add to the config, otherwise remove the option
    if [ -r "${SSL_DHPARAM_PATH}" ]; then
      sed 's,\(\#* *\)\?\(ssl_dhparam \).*\(;\)$,'"\2${SSL_DHPARAM_PATH}\3"',' -i ${NGINX_ONLYOFFICE_CONF}
    else
      sed '/ssl_dhparam/d' -i ${NGINX_ONLYOFFICE_CONF}
    fi

    sed 's,\(ssl_verify_client \).*\(;\)$,'"\1${SSL_VERIFY_CLIENT}\2"',' -i ${NGINX_ONLYOFFICE_CONF}

    if [ -f "${CA_CERTIFICATES_PATH}" ]; then
      sed '/ssl_verify_client/a '"ssl_client_certificate ${CA_CERTIFICATES_PATH}"';' -i ${NGINX_ONLYOFFICE_CONF}
    fi

    if [ "${ONLYOFFICE_HTTPS_HSTS_ENABLED}" == "true" ]; then
      sed 's,\(max-age=\).*\(;\)$,'"\1${ONLYOFFICE_HTTPS_HSTS_MAXAGE}\2"',' -i ${NGINX_ONLYOFFICE_CONF}
    else
      sed '/max-age=/d' -i ${NGINX_ONLYOFFICE_CONF}
    fi
  configure_ds_port
  else
    cp -f ${NGINX_ONLYOFFICE_PATH}/ds.conf.tmpl ${NGINX_ONLYOFFICE_CONF}
    configure_ds_port
  fi

  # check if ipv6 supported otherwise remove it from nginx config
  if [ ! -f /proc/net/if_inet6 ]; then
    sed '/listen\s\+\[::[0-9]*\].\+/d' -i $NGINX_ONLYOFFICE_CONF
  fi
}

configure_ds_port(){
  sed -i -e "s#\/etc\/nginx#${SNAP_DATA}\/etc\/nginx#g" ${NGINX_ONLYOFFICE_CONF}
  DS_PORT=$(snapctl get onlyoffice.ds-port)
  DSS_PORT=$(snapctl get onlyoffice.ds-ssl-port)
  sed -i "s/DS_PORT/"${DS_PORT}"/g"  $SNAP_DATA/etc/onlyoffice/documentserver/nginx/ds.conf
  sed -i "s/DSS_PORT/"${DSS_PORT}"/g"  $SNAP_DATA/etc/onlyoffice/documentserver/nginx/ds.conf
  cp -f ${NGINX_ONLYOFFICE_CONF} $SNAP_DATA/etc/nginx/conf.d/ds.conf
}

update_nginx_settings && \
$SNAP/bin/nginx
