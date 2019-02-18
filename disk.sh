#!/bin/bash
HOST="dev-gcm-db31 dev-gcm-db33 dev-gcm-db41 dev-gcm-db43 dev-gcm-db51 dev-gcm-db53"
SSH="~/.ssh/dev_gcmchef01.pem"

for i in ${HOST}
do
  echo "==== Disc Capacity for ${i} ============"
  ssh -i ${SSH} dev_gcmchef01@${i} "df -h"
  echo
  echo
done

exit 0
