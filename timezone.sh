write_message()
{
    ${ECHO} "${1}"
    ${ECHO} ""
}

# detect distribution

if [ -f /etc/redhat-release ]; then
    OSNAME=`cat /etc/redhat-release | awk '{print $1}'`
    if [ $OSNAME == "Red" ]; then
       ver=`cat /etc/redhat-release | awk '{print $7}' | awk -F'.' '{print $1}'`
       OS="redhat${ver}"
    else
        ver=`cat /etc/redhat-release | awk '{print $3}'`
        ver2=`cat /etc/redhat-release | awk '{print $4}'`
        if [ ${ver2} == "7.1.1503" ]; then
            OS="centos7.1"
        else
            OS="centos${ver}"
        fi
        echo ${OS}
    fi
    OS_STYLE="redhat"
elif [ -f /etc/lsb-release ]; then
    ver=`cat /etc/lsb-release | grep DISTRIB_RELEASE | awk -F'=' '{print $2}'`
    OS="ubuntu${ver}"
    OS_STYLE="debian"
else
    exit 255
fi

ALL_RUN_LEVEL=true

case ${OS} in
    redhat6)
        CURRENT_RUN_LEVEL=${CURRENT_RUN_LEVEL:-3}
    LN=/bin/ln
    ECHO=/bin/echo
        ;;
    centos6.3|centos6.5|centos7.1)
        CURRENT_RUN_LEVEL=${CURRENT_RUN_LEVEL:-3}
        AWK=/bin/awk
        RM=/bin/rm
    LN=/bin/ln
    GREP=/bin/grep
    TZSLCT=/usr/bin/tzselect
    CDATE=/bin/date
    ECHO=/bin/echo
    ;;
    centos5)
        CURRENT_RUN_LEVEL=${CURRENT_RUN_LEVEL:-3}
    CDATE=/bin/date
        AWK=/bin/awk
        RM=/bin/rm
        GREP=/bin/grep
        CP=/bin/cp
    LN=/bin/ln
    TZSLCT=/usr/bin/tzselect
    ECHO=/bin/echo
        ;;
    ubuntu12.10|ubuntu13.10|ubuntu14.04)
        CURRENT_RUN_LEVEL=${CURRENT_RUN_LEVEL:-2}
    TZCONFIG=/usr/sbin/dpkg-reconfigure
    SLEEP=/bin/sleep
    CDATE=/bin/date
    AWK=/usr/bin/awk
    ECHO=/bin/echo
        ;;
    *)
esac


###############Time Zone Change#########
${ECHO}
${ECHO}
${ECHO} -e "\e[33m############################################################"
${ECHO} -e "#                                                          #"
${ECHO} -e "#          Welcome to TimeZone configrator!                #"
${ECHO} -e "#                                                          #"
${ECHO} -e "############################################################\e[m"
${ECHO}
${ECHO} -e "You can change your VM's TimeZone with this script."
${ECHO} -e "Default TimeZone is set as UTC (Universal Time Clock)."
${ECHO}
CTZ=`${CDATE}|${AWK} '{print $5}'`
${ECHO} -e "Your current TimeZone is set as \e[33m ${CTZ}  \e[m"
${ECHO}
${ECHO}
${ECHO} -e "Do you want to continue the process? \e[33m(Y/N):\e[m"
${ECHO}
${ECHO} -n "#? "
read USER_ANSWER_START_TZCHANGE
${ECHO}
${ECHO}

case ${USER_ANSWER_START_TZCHANGE} in
"Y")
    ${ECHO} -e "\e[m"

    case ${OS} in
    redhat6)
        ${ECHO} "RHEL6 Detected. Booting redhat-config-date command."
        ${ECHO}
        ${SLEEP} 2s
        redhat-config-date
        exit 0
        ;;
    centos6.3|centos6.5|centos5|centos7.1)
        ${ECHO} -e "\e[33m ***Starting TimeZone Change Process***"
        ${ECHO} -e "Please choose the timezone you want to change.\e[m"
        ${ECHO} -e " ***Starting TimeZone select (tzselect)***"
        ${ECHO}
        TIMEZONE_SELECTED=`${TZSLCT} >&1 | ${AWK} '{print $NF}'`
        ${ECHO} -e " ***Time Zone select process was completed***"
        ${ECHO}
        ${ECHO}
        ${ECHO}
        ${ECHO} -e "\e[33m############################################################"
        ${ECHO} -e "#                                                          #"
        ${ECHO} -e "#                   [Confirmation]                         #"
        ${ECHO} -e "#     Your Server Configration will be overwritten.      #"
        ${ECHO} -e "#                                                          #"
        ${ECHO} -e "############################################################\e[m"
        ${ECHO}
        ${ECHO}
        ${ECHO} -e " Are you sure want to change your time setting to \e[m \e[33m ${TIMEZONE_SELECTED} ? \e[m"
        ${ECHO} -e "\e[31m This command immediately changes your timezone.\e[33m(Y/N): \e[m"
        ${ECHO}
        ${ECHO} -n "#?"
        read USER_ANSWER_TZCHANGE
        ${ECHO}
        ${ECHO}
        case ${USER_ANSWER_TZCHANGE} in
        "Y")
            ${ECHO} "starting TimeZone Changing..."
            TZ=${TIMEZONE_SELECTED}; export TZ
            if [ -e /etc/localtime ]; then
                ${ECHO} "/etc/localtime was found. Starting to delete..."
                ${RM} -f /etc/localtime
                ${ECHO} "/etc/localtime was deleted."
            fi
            ${ECHO} "Creating symbolic link to ${TIMEZONE_SELECTED}..."
            ${LN} -s /usr/share/zoneinfo/${TIMEZONE_SELECTED} /etc/localtime
            ${ECHO}
            ${ECHO}
            ${ECHO} -e "\e[33m Your TimeZone was successfully changed to ${TIMEZONE_SELECTED}!!! \e[m"
            ${ECHO}
            ;;
        "N")
            ${ECHO}
            ${ECHO} "exit program without any change."
            ${ECHO}
            ;;
        *)
            ${ECHO}
            ${ECHO} "please enter (Y/N). Please try again."
            ${ECHO}
            ;;
        esac
        ;;
    ubuntu12.10|ubuntu13.10|ubuntu14.04)
        ${ECHO} "Ubuntu Detected. Booting "dpkg-reconfigure tzdata"  command."
        ${ECHO} "You may needs to put your password run the command as sudo"
        ${SLEEP} 2s
        sudo ${TZCONFIG} tzdata
        ;;
    *)
        exit 255
    esac
    ;;
"N")
    ${ECHO} -e "Exit from program... \e[m"
    exit 0
    ;;
*)
    ${ECHO} -e "please enter (Y/N). Please try again. \e[m"
    exit 0
    ;;
esac
