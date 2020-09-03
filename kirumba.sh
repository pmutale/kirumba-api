#!/bin/bash

columns="$(tput cols)"
bold=$(tput bold)
#normal=$(tput sgr0)
normal=$(echo "\033[m")
menu=$(echo "\033[36m") #Blue
number=$(echo "\033[33m") #yellow
bgred=$(echo "\033[41m")
fgred=$(echo "\033[31m")
show_menu(){
    printf "${menu}*********************************************%s\n" "${normal}"
    printf "${menu}**${number} 1)${menu} Start Firebase Emulator ${normal}\n"
    printf "${menu}**${number} 2)${menu} Start all related Firebase Emulators ${normal}\n"
    printf "${menu}**${number} 3)${menu} Restart Apache ${normal}\n"
    printf "${menu}**${number} 4)${menu} ssh Frost TomCat Server ${normal}\n"
    printf "${menu}**${number} 5)${menu} Some other commands${normal}\n"
    printf "${menu}*********************************************${normal}\n"
    printf "Please enter a menu option and enter or ${fgred}x to exit. ${normal}"
    read opt
}

option_picked(){
    msgcolor=`echo "\033[01;31m"` # bold red
    normal=`echo "\033[00;00m"` # normal white
    message=${@:-"${normal}Error: No message passed"}
    printf "${msgcolor}${message}${normal}\n"
}

clear
show_menu
while [ $opt != '' ]
    do
    if [ $opt = '' ]; then
      exit;
    else
      case $opt in
        1) clear;
            option_picked "Option 1 Picked";
#            gcloud beta emulators firestore start --project tryout-dev --host-port "localhost:8001"
            firebase emulators:start
            show_menu;
        ;;
        2) clear;
            option_picked "Option 2 Picked";
            firebase emulators:start
            show_menu;
        ;;
        3) clear;
            option_picked "Option 3 Picked";
            printf "sudo service apache2 restart";
            show_menu;
        ;;
        4) clear;
            option_picked "Option 4 Picked";
            printf "ssh lmesser@ -p 2010";
            show_menu;
        ;;
        x)exit;
        ;;
        \n)exit;
        ;;
        *)clear;
            option_picked "Pick an option from the menu";
            show_menu;
        ;;
      esac
    fi
done