#!/bin/bash

name=$(basename "$0")

    #对7种颜色的加亮
    for i in `seq 30 37`;do
        echo -en "\x1b\x5b0;$i;1m $i;01m\e[0m"
    done
    echo  
    #7种颜色与7种背景的搭配
    for j in `seq 40 47`;do
        for i in `seq 30 37`;do
                echo -en "\x1b\x5b0;$i;"$j"m $i;"$j"m\e[0m"
        done
        echo
    done


        printf "\n"
        printf "ANSI 8Color Chart:\n"
        printf "\n"

        printf "\E[30m  0:  BLACK    "
        printf "\E[31m  1:  RED      "
        printf "\E[32m  2:  GREEN    "
        printf "\E[33m  3:  YELLOW   "
        printf "\E[34m  4:  BLUE     "
        printf "\E[35m  5:  MAGENTA  "
        printf "\E[36m  6:  CYAN     "
        printf "\E[37m  7:  WHITE  \n"
        printf "\E[0m"
        printf "\n"
        printf "\n"
        printf "XTERM 256Color Chart:\n"
        printf "\n"

        for i in `seq 0 8 255` ;do
            j=$((i*0x010101))
            printf "\E[38;5;$((i))m%03d:  %06x   "    $((i))    $((j))""
            printf "\E[38;5;$((i+1))m%03d:  %06x   " $((i+1)) "$((j+0x010000))"
            printf "\E[38;5;$((i+2))m%03d:  %06x   " $((i+2)) "$((j+0x000100))"
            printf "\E[38;5;$((i+3))m%03d:  %06x   " $((i+3)) "$((j+0x010100))"
            printf "\E[38;5;$((i+4))m%03d:  %06x   " $((i+4)) "$((j+0x000001))"
            printf "\E[38;5;$((i+5))m%03d:  %06x   " $((i+5)) "$((j+0x010001))"
            printf "\E[38;5;$((i+6))m%03d:  %06x   " $((i+6)) "$((j+0x000101))"
            printf "\E[38;5;$((i+7))m%03d:  %06x \n" $((i+7)) "$((j+0x010101))"

        done
        unset i j name
        printf "\E[0m"
        printf "\n"

exit 0

