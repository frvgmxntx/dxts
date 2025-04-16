#!/usr/bin/env bash

pgrep -f "gpu-screen-recorder" && pkill -INT -f gpu-screen-recorder && notify-send -h string:gpu-screen-recorder:record -t 1000 "Finished Recording" && exit 0

notify-send -h string:gpu-screen-recorder:record -t 1000 "Recording in:" "<span color='#90a4f4' font='26px'><i><b>2</b></i></span>"

sleep 1

notify-send -h string:gpu-screen-recorder:record -t 950 "Recording in:" "<span color='#90a4f4' font='26px'><i><b>1</b></i></span>"

sleep 1

dateTime=$(date +%m-%d-%Y-%H:%M:%S)
gpu-screen-recorder -w region -region $(slurp -f "%wx%h+%x+%y") -o $HOME/Videos/Screenrecords/$dateTime.mp4
