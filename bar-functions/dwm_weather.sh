#!/bin/sh

# A dwm_bar function to print the weather from wttr.in
# Joe Standring <git@joestandring.com>
# GNU GPLv3

# Dependencies: curl

# Change the value of LOCATION to match your city
dwm_weather() {
    LOCATION=Derventa

    if [ "$IDENTIFIER" = "" ]; then
        DATA=$(curl -s curl "https://api.openweathermap.org/data/2.5/weather?q=Derventa&appid=d6380fb4a05fea422589ea5b5dbfc35c&units=metric" | jq -r .main.temp)
        printf "${SEP1} ${DATA} ${SEP2}" 
    else
        DATA=$(curl -s curl "https://api.openweathermap.org/data/2.5/weather?q=Derventa&appid=d6380fb4a05fea422589ea5b5dbfc35c&units=metric" | jq -r .main.temp)
        printf "${SEP1}WEA +${DATA}${SEP2}"
    fi
}

dwm_weather
