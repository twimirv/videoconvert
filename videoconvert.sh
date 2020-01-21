#!/bin/bash
clear
echo "\033[1;31m"
echo ""
echo "PLUS-DESK VIDEO CONVERTER 2020"
echo "\033[3;90mPowered by: FFMPEG"
echo "\033[0m"
echo "This will convert all mp4-files in the folder for web use."
echo ""
echo "Current folder:\033[4;39m"
pwd
echo "\033[1;39m"
echo "Use default settings?\033[7;39m"
read -p "[y]/n?" defaultchoice
[ -z "${defaultchoice}" ] && defaultchoice='y'
echo "User choice: $defaultchoice"
clear
if [ $defaultchoice == "n" ]
then
    echo "\033[1;31m"
    echo "Custom settings (1/3)"
    echo "\033[0m"
    echo ""
    echo "Resolution [default: 1, enter to skip]"
    echo "\033[7;39m"
    read -p "1: 1080p | 2: 720p | 3: Both " resolution
    clear
    echo "\033[1;31m"
    echo "Custom settings (2/3)"
    echo "\033[0m"
    echo ""
    echo "Compression [default: 1, enter to skip]"
    echo "\033[7;39m"
    read -p "1: 26 | 2: Lossless | 3: Custom " bitrate
    clear
    echo "\033[1;31m"
    echo "Custom settings (3/3)"
    echo "\033[0m"
    echo ""
    echo "Encoding speed [default: 1, enter to skip]"
    echo "\033[7;39m"
    read -p "1: Medium | 2: Slowest (best compression) | 3: Fastest " speed
    clear

fi
[ -z "${resolution}" ] && resolution="1"
[ -z "${bitrate}" ] && bitrate="1"
[ -z "${speed}" ] && speed="1"

obitrate="-crf 26 -maxrate 8M -bufsize 6M "
ospeed="-preset slower "

if [[ $bitrate -eq 2 ]]
then
    obitrate="-crf 10 "
elif [[ $bitrate -eq 3 ]]
then
    read -p "\033[7;39mCustom compression (0-51): " cbitrate
    obitrate="-crf $cbitrate "
fi

if [[ $speed -eq 2 ]]
then
    ospeed="-preset veryslow "
elif [[ $speed -eq 3 ]]
then
    ospeed="-preset fast "
fi

echo "\033[0mConverting following files:"
for i in *.mp4
do
    echo $i
done
echo ""
echo "Options:"
echo $ospeed
echo $obitrate
echo $resolution
echo ""
echo "Continue?\033[7;39m"
read -p "[y]/n?" contconv
[ -z "${contconv}" ] && contconv='y'
clear
if [ $contconv == "y" ]
then
    ffmpegdir="ffmpeg" 
    if [ ! -d "$ffmpegdir" ]
    then
        echo "\033[0mCreating folder..."
        mkdir ffmpeg
        mkdir ffmpeg/1080p
        mkdir ffmpeg/720p

    else
        echo "\033[1;0mExisting files detected. Overwrite?"
        read -p "[y]/n?" overwrite
        [ -z "${overwrite}" ] && overwrite='y'
        if [ $overwrite == "n" ]
        then
        echo "\033[1;39mThank you for using \033[1;31mPLUS-DESK VIDEO CONVERTER 2020!\033[0m"
        exit
        fi
        mkdir ffmpeg/1080p
        mkdir ffmpeg/720p

    fi
    echo "\033[1;0mCONVERTING..."
    if [ $resolution -eq 1 ] || [ $resolution -eq 3 ]
    then
        echo "1080p PIPE"
        for i in *.mp4
            do ffmpeg -y -i $i -c:v libx264 $obitrate -vf format=yuv420p ${ospeed}ffmpeg/1080p/${i%.*}.mp4
        done
    fi
    if [ $resolution -eq 2 ] || [ $resolution -eq 3 ]
    then
        echo "720P PIPE"
        for i in *.mp4
            do ffmpeg -y -i $i -vf scale=-1:720 -c:v libx264 ${ospeed}ffmpeg/720p/${i%.*}.mp4
        done
    fi
fi

echo "Thank you for using \033[1;31mPLUS-DESK VIDEO CONVERTER 2020!\033[0m"
exit