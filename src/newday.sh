#!/usr/bin/env bash

# Simple script to create and open a new drawing for each day.
# dd_mm_yyyy

date=$(date +%d_%m_%Y)
time="[$(date +%H:%M:%S)]:"
name="KRITA_${date}.kra"
path="$(pwd)/drawings/${name}"
template="$(pwd)/templates/_TEMPLATE.kra"
hyprland=0
krita=0

if [[ $(hyprctl version) != 0 ]]; then
    hyprland=1
    echo "$time HYPRLAND DETECTED $hyprland"
fi

if [[ $(krita -v) != 0 ]]; then
    krita=1
    echo "$time KRITA DETECTED $krita"
fi

open_krita() {
    if [[ $hyprland && $krita ]]; then
        echo "$time HYPRCTL DISPATCHING KRITA ..."
        hyprctl dispatch exec krita "$path"
    elif $krita && ! $hyprland; then
        echo "$time OPENING KRITA FILE WITH KRITA ..."
        krita "$path" &
    else
        echo "$time OPENING WITH DEFAULT COMMAND ..."
        open "$path" &
    fi
}

if ! test -e ./drawings/"$name"; then
    cp $template "$path"
    echo "$time FILE CREATED SUCCESSFULLY: $name"
    open_krita

else
    echo "$time FILE ALREADY EXISTS: $name"
    open_krita
fi
