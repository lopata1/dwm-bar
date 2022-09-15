#!/bin/sh

# A dwm_bar function to show the current network connection/SSID, Wifi Strength, private IP using Connmanctl.
# procrastimax <heykeroth.dev@gmail.com>
# GNU GPLv3

# Dependencies: connman

dwm_connman () {
    printf "%s" "$SEP1"
    if [ "$IDENTIFIER" = "" ]; then
        printf "🌐 "
    else
        printf "NET "
    fi

    # get the connmanctl service name
    # this is a UID starting with 'vpn_', 'wifi_', or 'ethernet_', we dont care for the vpn one
    # if the servicename string is empty, there is no online connection
    IFS=':'
    ISCONNECTED=$(nmcli -t dev status | grep wlan0)
    read -a values<<<"$ISCONNECTED"
    ISCONNECTED=${values[2]}

    if [ "$ISCONNECTED" = "disconnected" ]; then
        printf "OFFLINE"
        printf "%s\n" "$SEP2"
        return
    else
	WIFINAME=${values[3]}
	STRENGTH=$(nmcli -t -f ssid,signal device wifi list | grep $WIFINAME)
	read -a values<<<"$STRENGTH"
	STRENGTH=${values[1]}
    fi

    # if STRENGTH is empty, we have a wired connection
    if [ "$STRENGTH" ]; then
        printf "%s str %s" "$WIFINAME" "$STRENGTH"
    else
        printf "%s" "$WIFINAME"
    fi

    printf "%s\n" "$SEP2"
}

dwm_connman
