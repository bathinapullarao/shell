#!/bin/bash

#yum install -y gcc gcc-c++ make patch automake autoconf \
yum install -y systemd-devel libacl-devel curl-devel libmcrypt-devel mhash-devel gd-devel libjpeg-devel libpng-devel libXpm-devel libxml2-devel libxslt-devel openssl-devel recode-devel 
#yum install openldap-devel net-snmp-devel

curl -s https://raw.githubusercontent.com/oscm/shell/master/database/mysql/5.7/mysql57-community-release.sh | bash
curl -s https://raw.githubusercontent.com/oscm/shell/master/database/mysql/5.7/mysql.devel.sh | bash

yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
yum install -y postgresql96-devel
