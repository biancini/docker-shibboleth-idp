#!/bin/bash

# This script prepares the Puppet Master for the synchronisation of a Puppet Agent.
# by putting the right institution's files into the right Puppet Master's directories.

MODULESDIR="/etc/puppet/modules"

#PUPPET_USER="root"
#PUPPET_SERVER="<YOUR_PUPPET_MASTER_FQDN>"
FILES="KO"
CERT="KO"

#prompt_file() {
#    scp $1 $PUPPET_USER@$PUPPET_SERVER:/etc/puppet/$2/$3
#}

generate_cert(){
  read -p "Insert the Domain Name for the HTTPS Certificate of the IdP to be installed [eg: example.com]: " DOMAIN_NAME
  
  if [[ "${DOMAIN_NAME}" =~ '^[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[it|com|net|org]' ]]; then
    echo "ERROR: you have to specify a valid Domain Name  for the IdP!"
    exit 1
  fi

  openssl req -newkey rsa:2048 -x509 -nodes -out config-files/${IDP_HOSTNAME}-cert-server.pem -keyout config-files/${IDP_HOSTNAME}-key-server.pem -days 3650 -subj "/CN=${IDP_HOSTNAME}.${DOMAIN_NAME}"
}

generate_default_files(){
  cp ${MODULESDIR}/shib2idp/files/tou/example-tou.html.txt config-files/${IDP_HOSTNAME}-tou.html
  cp ${MODULESDIR}/shib2idp/files/styles/sample-logo-32x32_en.png config-files/${IDP_HOSTNAME}-logo-32x32_en.png
  cp ${MODULESDIR}/shib2idp/files/styles/sample-logo-32x32_it.png config-files/${IDP_HOSTNAME}-logo-32x32_it.png
  cp ${MODULESDIR}/shib2idp/files/styles/sample-logo-160x120_en.png config-files/${IDP_HOSTNAME}-logo-160x120_en.png
  cp ${MODULESDIR}/shib2idp/files/styles/sample-logo-160x120_it.png config-files/${IDP_HOSTNAME}-logo-160x120_it.png
  cp ${MODULESDIR}/shib2idp/files/styles/sample-login.css config-files/${IDP_HOSTNAME}-login.css
}

mkdir config-files

IDP_FQDN=`hostname -f`
IDP_HOSTNAME=`echo ${IDP_FQDN} | awk -F. '{ print $1 }'`
DOMAIN_NAME=`echo ${IDP_FQDN} | awk -F. '{$1="";OFS="." ; print $0}' | sed 's/^.//' `

if [ -e $DOMAIN_NAME ]
then
	DOMAIN_NAME="local"
fi

echo "Now I create a new credential for you!"
generate_cert
CERT="OK"

echo "Now I create your configuration files using the default ones!"
generate_default_files
FILES="OK"

if [ ${FILES}==${CERT} ];
then
  cd config-files
  # prompt_file exec this => scp $1 $PUPPET_USER@$PUPPET_SERVER:/etc/puppet/$2/$3

  # prompt_file "${IDP_HOSTNAME}-key-server.pem" "modules/shib2common/files/certs" "${IDP_HOSTNAME}-key-server.pem"
  # prompt_file "${IDP_HOSTNAME}-cert-server.pem" "modules/shib2common/files/certs" "${IDP_HOSTNAME}-cert-server.pem"
  # prompt_file "${IDP_HOSTNAME}-tou.html" "modules/shib2idp/files/tou" "${IDP_HOSTNAME}-tou.html"

  # prompt_file "${IDP_HOSTNAME}-login.css" "modules/shib2idp/files/styles" "${IDP_HOSTNAME}-login.css"

  # prompt_file "${IDP_HOSTNAME}-logo-32x32_en.png" "modules/shib2idp/files/styles" "${IDP_HOSTNAME}-logo-32x32_en.png"
  # prompt_file "${IDP_HOSTNAME}-logo-32x32_it.png" "modules/shib2idp/files/styles" "${IDP_HOSTNAME}-logo-32x32_it.png"
  # prompt_file "${IDP_HOSTNAME}-logo-160x120_en.png" "modules/shib2idp/files/styles" "${IDP_HOSTNAME}-logo-160x120_en.png"
  # prompt_file "${IDP_HOSTNAME}-logo-160x120_it.png" "modules/shib2idp/files/styles" "${IDP_HOSTNAME}-logo-160x120_it.png"

  mv "${IDP_HOSTNAME}-key-server.pem" "${MODULESDIR}/shib2common/files/certs"
  mv "${IDP_HOSTNAME}-cert-server.pem" "${MODULESDIR}/shib2common/files/certs"
  mv "${IDP_HOSTNAME}-tou.html" "${MODULESDIR}/shib2idp/files/tou"

  mv "${IDP_HOSTNAME}-login.css" "${MODULESDIR}/shib2idp/files/styles"

  mv "${IDP_HOSTNAME}-logo-32x32_en.png" "${MODULESDIR}/shib2idp/files/styles"
  mv "${IDP_HOSTNAME}-logo-32x32_it.png" "${MODULESDIR}/shib2idp/files/styles"
  mv "${IDP_HOSTNAME}-logo-160x120_en.png" "${MODULESDIR}/shib2idp/files/styles"
  mv "${IDP_HOSTNAME}-logo-160x120_it.png" "${MODULESDIR}/shib2idp/files/styles"

  if [ ! -z "${MODULESDIR_TEST}" ]; then
      cp $MODULESDIR/shib2common/files/certs/$IDP_HOSTNAME-* $MODULESDIR_TEST/shib2common/files/certs
      cp $MODULESDIR/shib2idp/files/tou/$IDP_HOSTNAME-tou.html $MODULESDIR_TEST/shib2idp/files/tou
      cp $MODULESDIR/shib2idp/files/styles/$IDP_HOSTNAME-log* $MODULESDIR_TEST/shib2idp/files/styles
  fi

  #echo "Restarting puppet master on $PUPPET_SERVER..."
  #ssh $PUPPET_USER@$PUPPET_SERVER "service puppetmaster restart"
  #echo "Restarting Puppet Master"
  #service puppetmaster restart

  # I am into config-files directory here.
  #find . -type f -not -name "*.txt" | xargs rm

else
  echo "ERROR!!!"
fi

