#!/bin/bash -ue
# Super Telnet
# Telnet for all protocols. socat is awesome!

## defaults
verbose="false"
# default telnet port
port=23
# default protocol
proto="tcp"
ipv=4
# defaut address type
atype="TCP4"
# socat options
socat_opts=""

function print_usage() {
    cat <<EOF
Super Telnet: telnet for everything based on awesome socat

Usage: ${0} [-h|-4|-6|-g|-s|-u|-t] <host> <port>
    -h      Help.
    -a      Guess IP version for specified protocol
    -4      IPv4
    -6      IPv6
    -s      Protocol SCTP
    -t      Protocol TCP (default)
    -u      Protocol UDP

EOF
}


while getopts h46suta o
do
    case $o in
        h)
            print_usage ;;
        s)
            proto="sctp" ;;
        u)
            proto="udp" ;;
        t)
            proto="tcp" ;;
        4)
            ipv=4 ;;
        6)
            ipv=6 ;;
        a)
            [ "${verbose}" == "true" ] && echo "> use of ${proto}4/${proto}6 will be automatically determined"
            ipv="a"
    esac
done
shift $(($OPTIND-1))

[ $# -eq 0 ] && { echo 'No host specified'; print_usage; exit 1; }
[ $# -eq 2 ] && port="${2}"
host="${1}"

case $proto in 
    "tcp"|"udp")
        case $ipv in
            4)
                atype="${proto^^}4" ;;
            6)
                atype="${proto^^}6" ;;
            a)
                atype="${proto^^}" ;;
        esac ;;
    "sctp")
        case $ipv in
            4)
                atype="SCTP4-CONNECT" ;;
            6)
                atype="SCTP6-CONNECT" ;;
            a)
                atype="SCTP-CONNECT" ;;
        esac ;;
    *)
        echo "unknown protocol $proto"; exit 1 ;;
esac

socat -d ${socat_opts} READLINE,history=$HOME/.stelnet_history \
    ${atype}:${host}:${port},crnl

# vim: set filetype shell
