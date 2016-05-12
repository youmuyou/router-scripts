#!/bin/sh
# Traffic monitor from BCM switch
# Code is taken from https://github.com/RMerl/asuswrt-merlin/blob/2815dfc211f77c3216174510f6d58add3e72d4e4/release/src/router/shared/api-broadcom.c
# For Netgear R7000

# Parameter: port_num
get_port_tx_bytes() {
    PORT_PAGE=`expr $1 + 32` # 32 = 0x20
    TX_HEX=`et robord $PORT_PAGE 0x00 8`
    echo `printf %d $TX_HEX`
}

# Parameter: port_num
get_port_rx_bytes() {
    PORT_PAGE=`expr $1 + 32`
    RX_HEX=`et robord $PORT_PAGE 0x88 8`
    echo `printf %d $RX_HEX`
}

# No param
print_all() {
    for i in `seq 0 5`; do
        TX=$(get_port_tx_bytes $i)
        RX=$(get_port_rx_bytes $i)
        if [ $i == 5 ]; then
            PORT_TYPE=CPU
        elif [ $i == 8 ]; then
            PORT_TYPE=FA
        else
            PORT_TYPE=Switch
        fi
        echo Port $i \($PORT_TYPE\): TX \= $TX Bytes, RX \= $RX Bytes
    done
}

print_usage() {
    echo Traffic monitor for BCM5301x switch
    echo updateing @ GitHub
    echo 
    echo Usage: \[-t \| -r\] \[PORT_NUM\]
    echo "   -t Query TX bytes for given port"
    echo "   -r Query RX bytes for given port"
    echo "   PORT_NUM should be within 0~8"
    echo
    echo If no parameter given, traffic of all ports will be printed.
}

TXRX=$1
PORT=$2

if [ -z "$1" ] && [ -z "$2" ]; then
    print_all
elif [ -n "$1" ] && [ -n "$2" ]; then
    case $1 in
    "-t")
        get_port_tx_bytes $2
        ;;
    "-r")
        get_port_rx_bytes $2
        ;;
     *)
        print_usage
        ;;
     esac
else
    print_usage
fi
