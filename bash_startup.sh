#!/bin/sh
#user profile
#usage: just instert it in to the file ~/.bashrc the followings:
#
#if [ -f ~/your_scripts_path/bash_startup.sh ] ; then
#	. ~/your_scripts_path/bash_startup.sh your_scripts_path
#else
#	echo "Cannot initialize your workspace ..."
#fi	

#### If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

#### for shell prompts
#When start a new bash, PS1 will be unset,
#then will be reset to "\\s-\\v\\\$ " if interactive, 
#which means it needs to be set as needed.
#
PROMPT_COMMAND='echo -en "\e[1;30m" $(< /proc/loadavg)'
PS1=" \[\e[1;30m\][$$:$PPID - \j job(s)]\[\e[0m\]
\[\033[1m\]\$? \$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi)\
\[\e[0m\] \s \V \
\[\e[0;36m\]\t \d \
\[\e[0m\]\w\n\
\$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\e[1;30m\][\[\e[1;34m\]\u@\H\[\e[1;30m\]:\[\e[0m\]${SSH_TTY:-o} \[\e[0;32m\]+${SHLVL}\[\e[1;30m\]]'; fi)\
\[\033[01;34m\]\$\[\033[00m\] \
"
export HISTTIMEFORMAT='%F %T '

####local variables set
originalpath=`pwd`
scriptspath=$1

#### If variables have been set, don't set variables again.
[[ ":${PATH}:" = *:"$scriptspath/shell":* ]] && { unset originalpath scriptspath;return ; }

#### Begin....
echo -e "\e[32;1mInitializing something....\e[0m"
if [ -d $sriptspath ] ; then
	printf "\e[36;1mscripts directory existing. It seems right here. Continuing ...\e[0m\n"
else
	printf "\e[31;1mscripts directory not existing. workspace not set up?\e[0m\n"
fi

#### for GILDAS
if [ -d ~/.gag/init ] ; then
        printf "\e[33;1mGILAS...\e[0m"
       	export GAG_ROOT_DIR=/opt/gildas-exe-mar13a
        export GAG_EXEC_SYSTEM=x86_64-fedora17-gfortran-g95
        source $GAG_ROOT_DIR/etc/bash_profile

      # export GAG_ROOT_DIR=/home/snr/application/gildas-exe-may12b
      # export GAG_EXEC_SYSTEM=x86_64-fedora17-gfortran
      # source $GAG_ROOT_DIR/etc/bash_profile
else
	 printf "\e[31;1mGILDAS/CLASS not installed?\e[0m"
fi

#### for IRAF, scisoft
if [ -e /scisoft/bin/Setup.bash ] ; then
        printf "\e[33;1mIRAF...\e[0m\n"
        . /scisoft/bin/Setup.bash
else
        echo -e "\e[31;1mIRAF not installed?\e[0m"
fi

#### for starlink
export STARLINK_DIR=/opt/star-namaka
source $STARLINK_DIR/etc/profile
      echo  "Starlink gets ready."

#### for karma
if [ -d /usr/local/karma ] ; then
      . /usr/local/karma/.karmarc
      echo  "Karma gets ready."
fi

#### for IDL
. /home/xjshao/IDL/idl/bin/idl_setup.bash
export IDL_STARTUP=$scriptspath/idl_startup.pro
echo -e "\e[33;1mIDL STARTUP scprit:\e[0;32m $IDL_STARTUP\e[0m"

#### for shell
if [ -e $scriptspath/shell/pathmunge.sh ] ; then
        . $scriptspath/shell/pathmunge.sh $scriptspath/shell after
        . $scriptspath/shell/pathmunge.sh ~/.bin after
        . $scriptspath/shell/pathmunge.sh ~/.local/bin after
        printf "\e[33;1mBash path included:\e[0;32m $scriptspath/shell\e[0m\n"
else
        echo -e "\e[31;1mmy Bash path not included...\e[0m"
fi

#### for CASA
export PATH=$PATH:~/applications/Casa/casapy-42.1.29047-001-1-64b/bin

####
alias mv='mv -iv'
alias rm='rm -iv'
alias cp='cp -iv'
alias wget='wget -nc'
alias shutdown='qdbus org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout -1 -1 -1'
alias -p


#ibus-daemon &
# export GTK_IM_MODULE=ibus
# export XMODIFIERS=@im=ibus
# export QT_IM_MODULE=ibus

#ps -fe | grep /usr/libexec/deja-dup/deja-dup-monitor | grep xjshao | grep -v grep
#if [ $? -ne 0 ]
#    then
#    echo "start backup process....."
#    /usr/libexec/deja-dup/deja-dup-monitor &
#else
#    echo "deja-dup for me is runing....."
#fi


####
unset originalpath scriptspath

#### Greetings
echo -e "\e[32;1mInitialized.\e[0m"
echo -e "\e[32mPATH = $PATH \e[0m"
checkpath.sh | sort | uniq -c


