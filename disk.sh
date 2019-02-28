
#!/bin/bash
Sub="Warning : Disk error"
#sending mail to
to="Kannan.Vairamani@emeriocorp.com,Vajrala.Saisharma@emeriocorp.com,Bathina.Pullarao@emeriocorp.com"
CURRENT=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')
disc=$(df -h)
THRESHOLD1=90
if [[ "$CURRENT" -gt "$THRESHOLD1" ]]; then
echo    "Hi Infra Team,

**********************************************Disk Utilization  Alert****************************************
Running out of space / on server $(hostname), $(date), Disk utilization is: $CURRENT%



$disc
*************************************************************************************************************" | mail -s "$Sub" $to
fi
