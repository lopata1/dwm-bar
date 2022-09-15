#!/bin/sh

# A modular status bar for dwm
# Joe Standring <git@joestandring.com>
# GNU GPLv3

# Dependencies: xorg-xsetroot

# Import functions with "$include /route/to/module"
# It is recommended that you place functions in the subdirectory ./bar-functions and use: . "$DIR/bar-functions/dwm_example.sh"

# Store the directory the script is running from
LOC=$(readlink -f "$0")
DIR=$(dirname "$LOC")

# Change the appearance of the module identifier. if this is set to "unicode", then symbols will be used as identifiers instead of text. E.g. [📪 0] instead of [MAIL 0].
# Requires a font with adequate unicode character support
export IDENTIFIER="unicode"

# Change the charachter(s) used to seperate modules. If two are used, they will be placed at the start and end.
#export SEP1="["
export SEP2=" | "

# Import the modules
#. "$DIR/bar-functions/dwm_alarm.sh"
#. "$DIR/bar-functions/dwm_alsa.sh"
#. "$DIR/bar-functions/dwm_backlight.sh"
. "$DIR/bar-functions/dwm_battery.sh"
#. "$DIR/bar-functions/dwm_ccurse.sh"
#. "$DIR/bar-functions/dwm_cmus.sh"
. "$DIR/bar-functions/dwm_connman.sh"
#. "$DIR/bar-functions/dwm_countdown.sh"
#. "$DIR/bar-functions/dwm_currency.sh"
. "$DIR/bar-functions/dwm_date.sh"
#. "$DIR/bar-functions/dwm_keyboard.sh"
#. "$DIR/bar-functions/dwm_loadavg.sh"
#. "$DIR/bar-functions/dwm_mail.sh"
#. "$DIR/bar-functions/dwm_mpc.sh"
#. "$DIR/bar-functions/dwm_networkmanager.sh"
. "$DIR/bar-functions/dwm_pulse.sh"
#. "$DIR/bar-functions/dwm_resources.sh"
#. "$DIR/bar-functions/dwm_spotify.sh"
#. "$DIR/bar-functions/dwm_transmission.sh"
#. "$DIR/bar-functions/dwm_vpn.sh"
. "$DIR/bar-functions/dwm_weather.sh"

#parallelize() {
#    while true
#    do
#        #dwm_networkmanager &
#        dwm_weather &
#        sleep 120
#    done
#}
#parallelize &

#v_battery="$(dwm_battery)"
#v_connman="$(dwm_connman)"
#v_date="$(dwm_date)"
#v_pulse=$(dwm_pulse)

valuesAddr="/home/andre/dwm-bar/values"

touch $valuesAddr/pulse.val $valuesAddr/date.val $valuesAddr/weather.val $valuesAddr/net.val $valuesAddr/battery.val
#stdbuf -oL alsactl monitor default | while read -r; do
updateUpperBar() {
    upperbar=""
    #upperbar="$upperbar$(dwm_alarm)"
    #upperbar="$upperbar$(dwm_alsa)"
    #upperbar="$upperbar$(dwm_backlight)"
    #upperbar="$upperbar$(dwm_battery)"
    upperbar="$upperbar$(cat $valuesAddr/battery.val)"
    #upperbar="$upperbar$(dwm_ccurse)"
    #upperbar="$upperbar$(dwm_cmus)"
    #upperbar="$upperbar$(dwm_connman)"
    upperbar="$upperbar$(cat $valuesAddr/net.val)"
    #upperbar="$upperbar$(dwm_countdown)"
    #upperbar="$upperbar$(dwm_currency)"
    #upperbar="$upperbar$(dwm_date)"
    upperbar="$upperbar$(cat $valuesAddr/date.val)"
    #upperbar="$upperbar$(dwm_keyboard)"
    #upperbar="$upperbar$(dwm_loadavg)"
    #upperbar="$upperbar$(dwm_mail)"
    #upperbar="$upperbar$(dwm_mpc)"
    #upperbar="$upperbar$(dwm_pulse)"
    upperbar="$upperbar$(cat $valuesAddr/pulse.val)"
    #upperbar="$upperbar$(dwm_resources)"
    #upperbar="$upperbar$(dwm_spotify)"
    #upperbar="$upperbar$(dwm_transmission)"
    #upperbar="$upperbar$(dwm_vpn)"
    #upperbar="$upperbar${__DWM_BAR_NETWORKMANAGER__}"
    upperbar="$upperbar$(cat $valuesAddr/weather.val)"
   
    # Append results of each func one by one to the lowerbar string
    lowerbar=""
    if [ "$previous" != "$upperbar" ]; then
        xprop -root -set WM_NAME "$upperbar"
    fi
    export previous="$upperbar"
    # Uncomment the line below to enable the lowerbar 
    #xsetroot -name "$upperbar;$lowerbar"
}


updatePulse() {
    echo "$(dwm_pulse)" > $valuesAddr/pulse.val
    export rc=0
    stdbuf -oL pactl subscribe | while read pline; do
    	if [[ "$pline" == *"remove"* ]] && [ $rc -eq 0 ]; then
        	echo $(dwm_pulse) > $valuesAddr/pulse.val
		updateUpperBar
		export rc=1
	elif [ $rc -eq 1 ] && [[ "$pline" == *"remove"* ]]; then
		export rc=2
	elif [ $rc -eq 2 ] && [[ "$pline" == *"remove"* ]]; then
		export rc=0
	fi
    done
}
updateDate() {
    prevdate=""
    while true
    do
	date=$(dwm_date)
	if [ "$date" != "$prevdate" ]; then
            echo "$date" > $valuesAddr/date.val
	    updateUpperBar
	fi
	prevdate="$date"
	sleep 2
    done
}
updateWeatherAndBat() {
    echo "$(dwm_weather)" > $valuesAddr/weather.val
    echo "$(dwm_battery)" > $valuesAddr/battery.val
    while true
    do
	    echo "$(dwm_weather)" > $valuesAddr/weather.val
	    echo "$(dwm_battery)" > $valuesAddr/battery.val
	    updateUpperBar
	    sleep 120
    done
}
updateNet() {
    echo "$(dwm_connman)" > $valuesAddr/net.val
    nmcli monitor | while read -r; do
	    echo "$(dwm_connman)" > $valuesAddr/net.val
	    updateUpperBar
    done
}
updateNet2() {
    while true
    do
	    echo "$(dwm_connman)" > $valuesAddr/net.val
	    updateUpperBar
	    sleep 60
    done
}

updatePulse &
updateDate &
updateWeatherAndBat &
updateNet &
updateNet2 &

while true
do
	sleep 1000
done
