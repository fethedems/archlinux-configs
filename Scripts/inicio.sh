#!/bin/bash
#
# screenFetch (v2.4.0)
#
# Script to fetch system and theme settings for screenshots in most mainstream
# Linux distributions.
#
# This script is released under the General Public License (GPL). Though it's open
# source and you are free to do with it as you please, I would appreciate if you would
# send any code modifications/additions upstream to me so that I can include them in
# the official release. Please do not claim this code as your own as I have worked
# very hard on this and am quite proud to call this script my own.
#
# Yes, I do realize some of this is horribly ugly coding. Any ideas/suggestions would be
# appreciated by emailing me or by stopping by http://github.com/KittyKatt/screenFetch . You
# could also drop in on my IRC network, SilverIRC, at irc://kittykatt.silverirc.com:6667/meowz
# to put forth suggestions/ideas. Thank you.
#

scriptVersion="2.4.0"

######################
# Settings for fetcher
######################

# This setting controls what ASCII logo is displayed. Available: Arch Linux (Old and Current Logos), Linux Mint, Ubuntu, Crunchbang, Debian, Gentoo, Mandrake/Mandriva, Slackware, SUSE, Fedora, BSD, and None
# distro="Linux"

# This sets the information to be displayed. Available: distro, Kernel, DE, WM, Win_theme, Theme, Icons, Font, Background, ASCII. To get just the information, and not a text-art logo, you would take "ASCII" out of the below variable.
#display="host distro kernel uptime shell res de wm wmtheme gtk icons font background"
display=( host distro kernel uptime pkgs shell res de wm wmtheme gtk cpu mem )
# Display Type: ASCII or Text
display_type="ASCII"

# Colors to use for the information found. These are set below according to distribution. If you would like to set your OWN color scheme for these, uncomment the lines below and edit them to your heart's content.
# textcolor="\e[0m"
# labelcolor="\e[1;34m"

# WM & DE process names
# Removed WM's: compiz
wmnames="fluxbox openbox blackbox xfwm4 metacity kwin icewm pekwm fvwm dwm awesome wmaker stumpwm xmonad musca i3 ratpoison scrotwm wmfs wmii beryl subtle e16 enlightenment sawfish emerald monsterwm dminiwm"
denames="gnome-session xfce-mcs-manage xfce4-session xfconfd ksmserver lxsession gnome-settings-daemon mate-session mate-settings-daemon"

# Export theme settings
# screenFetch has the capability (on some WM's and GTK) to export your GTK and WM settings to an archive. Specify Yes if you want this and No if you do not.
exportTheme=

# Screenshot Settings
# This setting lets the script know if you want to take a screenshot or not. 1=Yes 0=No
screenshot=
# You can specify a custom screenshot command here. Just uncomment and edit. Otherwise, we'll be using the default command: scrot -cd3.
# screenCommand="scrot -cd5"
hostshot=
baseurl="http://www.example.com"
serveraddr="www.example.com"
scptimeout="20"
serverdir="/path/to/directory"
shotfile=$(echo "screenFetch-`date +'%Y-%m-%d_%H-%M-%S'`.png")

# Verbose Setting - Set to 1 for verbose output.
verbosity=

verboseOut () {
	echo -e "\e[1;31m:: \e[0m$1"
}

errorOut () {
	echo -e "\e[1;37m[[ \e[1;31m! \e[1;37m]] \e[0m$1"
}

#############################################
#### CODE No need to edit past here CODE ####
#############################################

####################
# Static Variables
####################
c0="\e[0m" # Reset Text
bold="\e[1m" # Bold Text
underline="\e[4m" # Underline Text
display_index=0

#####################
# Begin Flags Phase
#####################

while getopts ":hsmevVntlc:D:o:B" flags; do
	case $flags in
		h)
			echo -e "${underline}Usage${c0}:"
			echo -e "  screenFetch [OPTIONAL FLAGS]"
			echo ""
			echo "screenFetch - a CLI Bash script to show system/theme info in screenshots."
			echo ""
			echo -e "${underline}Supported Distributions${c0}:      Arch Linux (Old and Current Logos), Linux Mint,"
			echo -e "			      LMDE, Ubuntu, Crunchbang, Debian, Gentoo, Fedora, SolusOS,"
			echo -e "			      Mandrake/Mandriva, Slackware, Frugalware, openSUSE, Mageia,"
			echo -e "			      Peppermint, and BSD"
			echo -e "${underline}Supported Desktop Managers${c0}:   KDE, GNOME, XFCE, and LXDE, and Not Present"
			echo -e "${underline}Supported Window Managers${c0}:    PekWM, OpenBox, FluxBox, BlackBox, Xfwm4,"
			echo -e "			      Metacity, StumpWM, KWin, IceWM, FVWM,"
			echo -e "			      DWM, Awesome, XMonad, Musca, i3, WindowMaker,"
			echo -e "			      Ratpoison, wmii, WMFS, ScrotWM, subtle,"
			echo -e "			      Emerald, E17 and Beryl."
			echo ""
			echo -e "${underline}Options${c0}:"
			echo -e "   ${bold}-v${c0}                 Verbose output."
			echo -e "   ${bold}-o 'OPTIONS'${c0}       Allows for setting script variables on the"
			echo -e "		      command line. Must be in the following format..."
			echo -e "		      'OPTION1=\"OPTIONARG1\";OPTION2=\"OPTIONARG2\"'"
			#echo -e "   ${bold}-d 'ARGUMENTS'${c0}     Allows for setting what information is displayed"
			#echo -e "		      on the command line. Format must be as follows:"
			#echo -e "		      'OPTION OPTION OPTION OPTION'. Valid options are"
			#echo -e "		      host, distro, Kernel, Uptime, Shell, Resolution, DE, WM,"
			#echo -e "		      Win_theme, Theme, Icons, Font, ASCII, Background."
			echo -e "   ${bold}-n${c0}                 Do no display ASCII distribution logo."
			echo -e "   ${bold}-t${c0}                 Truncate output based on terminal width (Experimental!)."
			echo -e "   ${bold}-s(m)${c0}              Using this flag tells the script that you want it"
			echo -e "		      to take a screenshot. Use the -m flag if you would like"
			echo -e "		      to move it to a new location afterwards."
			echo -e "   ${bold}-B${c0}                 Enable background detection."
			echo -e "   ${bold}-e${c0}                 When this flag is specified, screenFetch will attempt"
			echo -e "		      to export all of your theme settings and archive them"
			echo -e "		      up for uploading."
			echo -e "   ${bold}-l${c0}                 Specify that you have a light background. This turns"
			echo -e "		      all white text into dark gray text (in ascii logos and"
			echo -e "		      in information output)."
			echo -e "   ${bold}-c 'COMMAND'${c0}       Here you can specify a custom screenshot command for"
			echo -e "		      the script to execute. Surrounding quotes are required."
			echo -e "   ${bold}-D 'DISTRO'${c0}        Here you can specify your distribution for the script"
			echo -e "		      to use. Surrounding quotes are required."
			echo -e "   ${bold}-V${c0}                 Display current script version."
			echo -e "   ${bold}-h${c0}                 Display this help."
			exit
		;;
		s) screenshot=1; continue;;
		m) hostshot=1; continue;;
		e) exportTheme=1; continue;;
		v) verbosity=1; continue;;
		V)
			echo -e $underline"screenFetch"$c0" - Version $scriptVersion"
			echo "Created by and licensed to Brett Bohnenkamper (kittykatt@silverirc.com)"
			echo ""
			echo "This is free software; see the source for copying conditions.  There is NO warranty; not even MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."
			exit
		;;
		D) distro=$OPTARG; continue;;
		t) truncateSet="Yes";;
		c) screenCommand=$OPTARG; continue;;
		n) display_type="Text";;
		o) overrideOpts=$OPTARG; continue;;
		# d) overrideDisplay=$OPTARG; continue;;
		l) c1="\e[1;30m";;
		# B) background_detect="1"; continue;;
		:) errorOut "Error: You're missing an argument somewhere. Exiting."; exit;;
		?) errorOut "Error: Invalid flag somewhere. Exiting."; exit;;
		*) errorOut "Error"; exit;;
	esac
done

###################
# End Flags Phase
###################


####################
# Override Options
####################

if [[ "$overrideOpts" ]]; then
	[[ "$verbosity" -eq "1" ]] && verboseOut "Found 'o' flag in syntax. Overriding some script variables..."
	OLD_IFS="$IFS"
	IFS=";"
	for overopt in "$overrideOpts"; do
		eval "$overrideOpts"
	done
	IFS="$OLD_IFS"
fi
#if [[ "$overrideDisplay" ]]; then
#	[[ "$verbosity" -eq "1" ]] && verboseOut "Found 'd' flag in syntax. Overriding some display options..."
#	display="$overrideDisplay"
#fi


#########################
# Begin Detection Phase
#########################


# Host and User detection - Begin
detecthost () {
	myUser=$(echo "$USER")
	myHost=$(hostname)
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding hostname and user...found as '$myUser@$myHost'"
}


#########################
# Begin Detection Phase
#########################


# Host and User detection - Begin
detecthost () {
	myUser=$(echo "$USER")
	# net-tools is becoming deprecated
	# myHost=$(hostname)
	myHost=$(cat /proc/sys/kernel/hostname)
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding hostname and user...found as '$myUser@$myHost'"
}

# Distro Detection - Begin
detectdistro () {
	if [[ -z $distro ]]; then
		distro="Unknown"
		# LSB Release Check
		if which lsb_release >/dev/null 2>&1; then
			distro_detect=$(lsb_release -i | sed -e 's/Distributor ID://' -e 's/\t//g')
			if [ "$distro_detect" == "Arch" ]; then distro="Arch Linux"; fi
			if [ "$distro_detect" == "Debian" ]; then distro="Debian"; fi
			if [ "$distro_detect" == "SolusOS" ]; then
				distro="SolusOS"
				distro_codename=null
				distro_release=null
			fi
			if [ "$distro_detect" == "LinuxMint" ]; then distro="Mint"
				if [ "$(lsb_release -c | sed -e 's/Codename://' -e 's/\t//g')" == "debian" ]; then
					distro="LMDE"
					distro_codename=null
					distro_release=null
				fi
			fi
			if [ "$distro_detect" == "Mageia" ]; then distro="Mageia"; fi
			if [ "$distro_detect" == "MandrivaLinux" ]; then distro="Mandriva"
				if [ "$(lsb_release -c | sed -e 's/Codename://' -e 's/\t//g')" == "turtle" ]; then
					distro="Mandriva"-lsb_release | sed -e 's/Release://' -e 's/\t//g'
					distro_codename=null
				fi
				if [ "$(lsb_release -c | sed -e 's/Codename://' -e 's/\t//g')" == "Henry_Farman" ]; then
					distro="Mandriva"-lsb_release | sed -e 's/Release://' -e 's/\t//g'
					distro_codename=null
				fi
				if [ "$(lsb_release -c | sed -e 's/Codename://' -e 's/\t//g')" == "Farman" ]; then
					distro="Mandriva"-lsb_release | sed -e 's/Release://' -e 's/\t//g'
					distro_codename=null
				fi
				if [ "$(lsb_release -c | sed -e 's/Codename://' -e 's/\t//g')" == "Adelie" ]; then
					distro="Mandriva"-lsb_release | sed -e 's/Release://' -e 's/\t//g'
					distro_codename=null
				fi
				if [ "$(lsb_release -c | sed -e 's/Codename://' -e 's/\t//g')" == "pauillac" ]; then
					distro="Mandriva"-lsb_release | sed -e 's/Release://' -e 's/\t//g'
					distro_codename=null
				fi
			fi
			if [ "$distro_detect" == "Fedora" ]; then distro="Fedora"; fi
			if [ "$distro_detect" == "CrunchBang" ]; then distro="CrunchBang"; fi
			if [ "$distro_detect" == "Ubuntu" ]; then distro="Ubuntu"; fi
			if [ "$distro_detect" == "frugalware" ]; then
				distro="Frugalware"
				distro_codename=null
				distro_release=null
			fi
			if [ "$distro_detect" == "Peppermint" ]; then
				distro="Peppermint"
				distro_codename=null
			fi
			if [ "$distro_detect" == "SUSE LINUX" ]; then distro="openSUSE"; fi
			if [[ $(lsb_release -r | sed -e 's/Release://' -e 's/\t//g') != "n/a" ]] && [[ ! $distro_release ]]; then distro_release=$(lsb_release -r | sed -e 's/Release://' -e 's/\t//g') && distro_more="$distro $distro_release"; fi
			if [[ $(lsb_release -c | sed -e 's/Codename://' -e 's/\t//g') != "n/a" ]] && [[ ! $distro_codename ]]; then distro_codename=$(lsb_release -c | sed -e 's/Codename://' -e 's/\t//g') && distro_more="$distro $distro_codename"; fi
		# Existing File Check
		else
			if [ -f /etc/os-release ]; then
				distrib_id=$(awk -F'=' '/^ID/{print $2}' /etc/os-release 2>/dev/null)
				if [ "$distrib_id" == "frugalware" ]; then distro="Frugalware"; fi
			fi
			if [ -f /etc/debian_version ]; then distro="Debian"; fi
			if grep -i ubuntu /etc/lsb-release >/dev/null 2>&1; then distro="Ubuntu"; fi
			if grep -i SolusOS /etc/issue >/dev/null 2>&1; then distro="SolusOS"; fi
			if grep -i mint /etc/lsb-release >/dev/null 2>&1; then
				if grep -i debian /etc/lsb-release >/dev/null 2>&1; then distro="LMDE"
				else distro="Mint"; fi
			fi
			if [ -f /etc/arch-release ]; then distro="Arch Linux"; fi
			if [ -f /etc/fedora-release ]; then distro="Fedora"; fi
			if [ -f /etc/redhat-release ]; then distro="Red Hat Linux"; fi
			if [ -f /etc/slackware-version ]; then distro="Slackware"; fi
			if [ -f /etc/SuSE-release ]; then distro="openSUSE"; fi
			if [ -f /etc/mageia-release ]; then distro="Mageia"; fi
			if [ -f /etc/mandrake-release ]; then distro="Mandrake"; fi
			if [ -f /etc/mandriva-release ]; then distro="Mandriva"; fi
			if [ -f /etc/crunchbang-lsb-release ]; then distro="CrunchBang"; fi
			if [ -f /etc/gentoo-release ]; then distro="Gentoo"; fi
			if [ -f /var/run/dmesg.boot ] && grep -i bsd /var/run/dmesg.boot; then distro="BSD"; fi
			if [ -f /usr/share/doc/tc/release.txt ]; then distro="TinyCore"; fi
			if [ -f /etc/frugalware-release ]; then distro="Frugalware"; fi
			if grep -q "SolusOS" /etc/issue; then distro="SolusOS"; fi
		fi
	else
		declare -l lcase
		lcase=$distro
		case $lcase in
			arch*linux*old) distro="Arch Linux - Old" ;;
			arch*linux) distro="Arch Linux" ;;
			fedora) distro="Fedora" ;;
			mageia) distro="Mageia" ;;
			mandriva) distro="Mandriva" ;;
			mandrake) distro="Mandrake" ;;
			crunchbang) distro="CrunchBang" ;;
			mint) distro="Mint" ;;
			lmde) distro="LMDE" ;;
			opensuse) distro="openSUSE" ;;
			ubuntu) distro="Ubuntu" ;;
			debain) distro="Debian" ;;
			bsd) distro="BSD" ;;
			red*hat*) distro="Red Hat Linux" ;;
			crunchbang) distro="CrunchBang" ;;
			gentoo) distro="Gentoo" ;;
			slackware) distro="Slackware" ;;
			frugalware) distro="Frugalware" ;;
			peppermint) distro="Peppermint" ;;	 
		esac
	fi	
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding distro...found as '$distro $distro_release'"
}
# Distro Detection - End

# Find Number of Running Processes
# processnum="$(( $( ps aux | wc -l ) - 1 ))"

# Kernel Version Detection - Begin
detectkernel () {
	kernel=`uname -r`
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding kernel version...found as '$kernel'"
}
# Kernel Version Detection - End


# Uptime Detection - Begin
detectuptime () {
	uptime=`awk -F. '{print $1}' /proc/uptime`
	secs=$((${uptime}%60))
	mins=$((${uptime}/60%60))
	hours=$((${uptime}/3600%24))
	days=$((${uptime}/86400))
	uptime="${mins}m"
	if [ "${hours}" -ne "0" ]; then
		uptime="${hours}h ${uptime}"
	fi
	if [ "${days}" -ne "0" ]; then
		uptime="${days}d ${uptime}"
	fi
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding current uptime...found as '$uptime'"
}
# Uptime Detection - End


# Package Count - Begin
detectpkgs () {
	case $distro in
		'Arch Linux') pkgs=$(pacman -Qq | wc -l) ;;
		'Frugalware') pkgs=$(pacman-g2 -Qq | wc -l) ;;
		'Ubuntu'|'Mint'|'SolusOS'|'Debian'|'LMDE'|'CrunchBang'|'Peppermint') pkgs=$(dpkg --get-selections | wc -l) ;;
		'Slackware') pkgs=$(ls -1 /var/log/packages | wc -l) ;;
		'Gentoo') pkgs=$(ls -d /var/db/pkg/*/* | wc -l) ;;
		'Fedora'|'openSUSE'|'Red Hat Linux'|'Mandriva'|'Mandrake'|'Mageia') pkgs=$(rpm -qa | wc -l) ;;
	esac
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding current package count...found as '$pkgs'"
}




# CPU Detection - Begin
detectcpu () {
	cpu=$(awk -F':' '/model name/{ print $2 }' /proc/cpuinfo | head -n 1 | tr -s " " | sed 's/^ //')
	# cpu_mhz=$(awk -F':' '/cpu MHz/{ print $2 }' /proc/cpuinfo | head -n 1)
	# cpu_ghz=$(echo "scale=2; ${cpu_mhz} / 1000" | bc )
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding current CPU...found as '$cpu'"
}
# CPU Detection - End



# Memory Detection - Begin
detectmem () {
	total_mem=$(awk '/MemTotal/ { print $2 }' /proc/meminfo)
	totalmem=$((${total_mem}/1024))
	if free | grep -q '/cache'; then
		used_mem=$(free | awk '/cache:/ { print $3 }')
		usedmem=$((${used_mem}/1024))
	else
		free_mem=$(awk '/MemFree/ { print $2 }' /proc/meminfo)
		used_mem=$((${total_mem} - ${free_mem}))
		usedmem=$((${used_mem}/1024))
	fi
	mem="${usedmem}MB / ${totalmem}MB"
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding current RAM usage...found as '$mem'"
}
# Memory Detection - End


# Shell Detection - Begin
detectshell () {
	myShell=$(echo $SHELL | awk -F"/" '{print $NF}')
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding current shell...found as '$myShell'"
}
# Shell Detection - End


# Resolution Detection - Begin
detectres () {
	if [[ -n $DISPLAY ]]; then
		xResolution=$(xdpyinfo | sed -n 's/.*dim.* \([0-9]*x[0-9]*\) .*/\1/pg' | sed ':a;N;$!ba;s/\n/ /g')
	else
		xResolution="No X Server"
	fi
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding current resolution(s)...found as '$xResolution'"
}
# Resolution Detection - End


# DE Detection - Begin
detectde () {
	DE="Not Present"
		for each in $denames; do
			if [[ `ps aux` =~ "$each" ]]; then
				[ "$each" == "gnome-session" -o "$each" == "gnome-settings-daemon" ] && DE="GNOME" && DEver=$(gnome-session --version | awk {'print $NF'})
				[ "$each" == "mate-session" -o "$each" == "mate-settings-daemon" ] && DE="MATE" && DEver=$(mate-session --version | awk {'print $NF'})
				[ "$each" == "xfce4-session" ] && DE="XFCE" && DEver=$(xfce4-settings-manager --version | grep -m 1 "" | awk {'print $2'})
				[ "$each" == "ksmserver" ] && DE="KDE" && DEver=$(kwin --version | awk '/^Qt/ {data="Qt v" $2};/^KDE/ {data=$2 " (" data ")"};END{print data}')
				[ "$each" == "lxsession" ] && DE="LXDE" && DEver=$(lxpanel -v)
			fi
		done
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding desktop environment...found as '$DE'"
}
### DE Detection - End


# WM Detection - Begin
detectwm () {
WM="Not Found"
	userId="$(id -u ${USER})"
	for each in $wmnames; do
		PID="$(pgrep -U ${userId} $each)"
		if [ "$PID" ]; then
			case $each in
				'fluxbox') WM="FluxBox";;
				'openbox') WM="OpenBox";;
				'blackbox') WM="Blackbox";;
				'xfwm4') WM="Xfwm4";;
				'metacity') WM="Metacity";;
				'kwin') WM="KWin";;
				'icewm') WM="IceWM";;
				'pekwm') WM="PekWM";;
				'fvwm') WM="FVWM";;
				'dwm') WM="DWM";;
				'awesome') WM="Awesome";;
				'wmaker') WM="WindowMaker";;
				'stumpwm') WM="StumpWM";;
				'xmonad') WM="XMonad";;
				'musca') WM="Musca";;
				'i3') WM="i3";;
				'ratpoison') WM="Ratpoison";;
				'scrotwm') WM="ScrotWM";;
				'wmfs') WM="WMFS";;
				'wmii') WM="wmii";;
				'subtle') WM="subtle";;
				'e16') WM="E16";;
				'enlightenment') WM="E17";;
				'emerald') WM="Emerald";;
				'sawfish') WM="Sawfish";;
				'beryl') WM="Beryl";;
				'monsterwm') WM="monsterwm";;
				'dminiwm') WM="dminiwm";;
			esac
		fi
	done
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding window manager...found as '$WM'"
}
# WM Detection - End


# WM Theme Detection - BEGIN
detectwmtheme () {
	Win_theme="Not Found"
	case $WM in
		'PekWM') if [ -f $HOME/.pekwm/config ]; then Win_theme="$(awk -F"/" '/Theme/ {gsub(/\"/,""); print $NF}' $HOME/.pekwm/config)"; fi;;
		'OpenBox') 
			if [ -f ${XDG_CONFIG_HOME:-${HOME}/.config}/openbox/rc.xml ]; then 
				Win_theme="$(awk -F"[<,>]" '/<theme/ { getline; print $3 }' ${XDG_CONFIG_HOME:-${HOME}/.config}/openbox/rc.xml)"; 
			elif [[ -f ${XDG_CONFIG_HOME:-${HOME}/.config}/openbox/lxde-rc.xml && $DE == "LXDE" ]]; then 
				Win_theme="$(awk -F"[<,>]" '/<theme/ { getline; print $3 }' ${XDG_CONFIG_HOME:-${HOME}/.config}/openbox/lxde-rc.xml)"; 
			fi;;
		'FluxBox') if [ -f $HOME/.fluxbox/init ]; then Win_theme="$(awk -F"/" '/styleFile/ {print $NF}' $HOME/.fluxbox/init)"; fi;;
		'BlackBox') if [ -f $HOME/.blackboxrc ]; then Win_theme="$(awk -F"/" '/styleFile/ {print $NF}' $HOME/.blackboxrc)"; fi;;
		'Metacity') if [ "`gconftool-2 -g /apps/metacity/general/theme`" ]; then Win_theme="$(gconftool-2 -g /apps/metacity/general/theme)"; fi ;;
		'Xfwm4') if [ -f ${XDG_CONFIG_HOME:-${HOME}/.config}/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml ]; then Win_theme="$(xfconf-query -c xfwm4 -p /general/theme)"; fi;;
		'IceWM') if [ -f $HOME/.icewm/theme ]; then Win_theme="$(awk -F"[\",/]" '!/#/ {print $2}' $HOME/.icewm/theme)"; fi;;
		'KWin') if [ -f $HOME/.kde/share/config/plasmarc ]; then Win_theme="$(awk -F"=" '/^name=/ { getline; print $2 }' ${HOME}/.kde/share/config/plasmarc | head -1)"; else Win_theme="Not Present"; fi;;
		'Emerald') if [ -f $HOME/.emerald/theme/theme.ini ]; then Win_theme="$(for a in /usr/share/emerald/themes/* $HOME/.emerald/themes/*; do cmp "$HOME/.emerald/theme/theme.ini" "$a/theme.ini" &>/dev/null && basename "$a"; done)"; fi;;
		'FVWM') Win_theme="Not Present";;
		'DWM') Win_theme="Not Present";;
		'Awesome') if [ -f ${XDG_CONFIG_HOME:-${HOME}/.config}/awesome/rc.lua ]; then Win_theme="$(grep -e '^[^-].*\(theme\|beautiful\).*lua' ${XDG_CONFIG_HOME:-${HOME}/.config}/awesome/rc.lua | grep '[a-zA-Z0-9]\+/[a-zA-Z0-9]\+.lua' -o | cut -d'/' -f1)"; fi;;
		'WindowMaker') Win_theme="Not Present";;
		'XMonad') Win_theme="Not Present";;
		'Musca') Win_theme="Not Present";;
		'i3') Win_theme="Not Present";;
		'Ratpoison') Win_theme="Not Present";;
		'ScrotWM') Win_theme="Not Present";;
		'WMFS') Win_theme="Not Present";;
		'wmii') Win_theme="Not Present";;
		'subtle') Win_theme="Not Present";;
		'E16') Win_theme="$(awk -F"= " '/theme.name/ {print $2}' $HOME/.e16/e_config--0.0.cfg)";;
		#E17 doesn't store cfg files in text format so for now get the profile as opposed to theme. atyoung
		#TODO: Find a way to extract and read E17 .cfg files ( google seems to have nothing ). atyoung
		'E17') Win_theme=${E_CONF_PROFILE};;
		'Sawfish') Win_theme="$(awk -F")" '/\(custom-set-typed-variable/{print $2}' $HOME/.sawfish/custom | sed 's/ (quote //')";;
		'Beryl') Win_theme="Not Present";;
		'monsterwm') Win_theme="Not Present";;
		'dminiwm') Win_theme="Not Present";;
	esac
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding window manager theme...found as '$Win_theme'"
}
# WM Theme Detection - END

# GTK Theme\Icon\Font Detection - BEGIN
detectgtk () {
	gtkTheme="Not Found"
	gtkIcons="Not Found"
	gtkFont="Not Found"
	case $DE in
		'KDE')	# Desktop Environment found as "KDE"
			if [ -a $HOME/.kde/share/config/kdeglobals ]; then
				if grep -q "widgetStyle=" $HOME/.kde/share/config/kdeglobals; then
					gtkTheme=$(awk -F"=" '/widgetStyle=/ {print $2}' $HOME/.kde/share/config/kdeglobals)
				elif grep -q "colorScheme=" $HOME/.kde/share/config/kdeglobals; then
					gtkTheme=$(awk -F"=" '/colorScheme=/ {print $2}' $HOME/.kde/share/config/kdeglobals)
				fi

				if grep -q "Theme=" $HOME/.kde/share/config/kdeglobals; then
					gtkIcons=$(awk -F"=" '/Theme=/ {print $2}' $HOME/.kde/share/config/kdeglobals)
				fi

				if grep -q "Font=" $HOME/.kde/share/config/kdeglobals; then
					gtkFont=$(awk -F"=" '/font=/ {print $2}' $HOME/.kde/share/config/kdeglobals)
				fi
			fi
		;;
		'GNOME'|'MATE') # Desktop Environment found as "GNOME"
			if which gconftool-2 >/dev/null 2>&1; then
				gtkTheme=$(gconftool-2 -g /desktop/gnome/interface/gtk_theme)
			fi

			if which gconftool-2 >/dev/null 2>&1; then
				gtkIcons=$(gconftool-2 -g /desktop/gnome/interface/icon_theme)
			fi

			if which gconftool-2 >/dev/null 2>&1; then
				gtkFont=$(gconftool-2 -g /desktop/gnome/interface/font_name)
			fi
			if [ "$background_detect" == "1" ]; then
				if which gconftool-2 >/dev/null 2>&1; then
					gtkBackgroundFull=$(gconftool-2 -g /desktop/gnome/background/picture_filename)
					gtkBackground=$(echo "$gtkBackgroundFull" | awk -F"/" '{print $NF}')
				fi
			fi
		;;
		'XFCE')	# Desktop Environment found as "XFCE"
			if which xfconf-query >/dev/null 2>&1; then
				gtkTheme=$(xfconf-query -c xsettings -p /Net/ThemeName)
			fi

			if which xfconf-query >/dev/null 2>&1; then
				gtkIcons=$(xfconf-query -c xsettings -p /Net/IconThemeName)
			fi

			if which xfconf-query >/dev/null 2>&1; then
				gtkFont=$(xfconf-query -c xsettings -p /Gtk/FontName)
			fi
		;;
		'LXDE')
			if [ -f ${XDG_CONFIG_HOME:-${HOME}/.config}/lxde/config ]; then
				lxdeconf="/lxde/config"
			else
				lxdeconf="/lxsession/LXDE/desktop.conf"
			fi
			# TODO: Clean me.
			if grep -q "sNet\/ThemeName" ${XDG_CONFIG_HOME:-${HOME}/.config}$lxdeconf; then 
			 gtkTheme=$(awk -F'=' '/sNet\/ThemeName/ {print $2}' ${XDG_CONFIG_HOME:-${HOME}/.config}$lxdeconf)
			fi

			if grep -q IconThemeName ${XDG_CONFIG_HOME:-${HOME}/.config}$lxdeconf; then
				gtkIcons=$(awk -F'=' '/sNet\/IconThemeName/ {print $2}' ${XDG_CONFIG_HOME:-${HOME}/.config}$lxdeconf)
			fi

			if grep -q FontName ${XDG_CONFIG_HOME:-${HOME}/.config}$lxdeconf; then
				gtkFont=$(awk -F'=' '/sGtk\/FontName/ {print $2}' ${XDG_CONFIG_HOME:-${HOME}/.config}$lxdeconf)
			fi	 
		;;

		# /home/me/.config/rox.sourceforge.net/ROX-Session/Settings.xml

		*)	# Lightweight or No DE Found
			if [ -f $HOME/.gtkrc-2.0 ]; then
				if grep -q gtk-theme $HOME/.gtkrc-2.0; then 
					gtkTheme=$(awk -F'"' '/gtk-theme/ {print $2}' $HOME/.gtkrc-2.0)
				fi

				if grep -q icon-theme $HOME/.gtkrc-2.0; then
					gtkIcons=$(awk -F'"' '/icon-theme/ {print $2}' $HOME/.gtkrc-2.0)
				fi

				if grep -q font $HOME/.gtkrc-2.0; then
					gtkFont=$(awk -F'"' '/gtk-font-name/ {print $2}' $HOME/.gtkrc-2.0)
				fi
			fi
			# $HOME/.gtkrc.mine theme detect only
			if [ -f $HOME/.gtkrc.mine ]; then
				if grep -q "^include" $HOME/.gtkrc.mine; then
					gtkTheme=$(grep '^include.*gtkrc' $HOME/.gtkrc.mine | awk -F "/" '{ print $5 }')
				fi
				if grep -q "^gtk-icon-theme-name" $HOME/.gtkrc.mine; then
					gtkIcons=$(grep 'gtk-icon-theme-name' $HOME/.gtkrc.mine | awk -F '"' '{print $2}')
				fi
			fi
			# ROX-Filer icon detect only
			if [ -a ${XDG_CONFIG_HOME:-${HOME}/.config}/rox.sourceforge.net/ROX-Filer/Options ]; then
				gtkIcons=$(awk -F'[>,<]' '/icon_theme/ {print $3}' ${XDG_CONFIG_HOME:-${HOME}/.config}/rox.sourceforge.net/ROX-Filer/Options)
			fi
			# E17 detection
			if [ $E_ICON_THEME ]; then
				gtkIcons=${E_ICON_THEME}
				gtkTheme="Not available."
				gtkFont="Not available."
			fi
			# Background Detection (feh, nitrogen)
			if [ "$background_detect" == "1" ]; then
				if [ -a $HOME/.fehbg ]; then
					gtkBackgroundFull=$(awk -F"'" '/feh --bg/{print $2}' $HOME/.fehbg 2>/dev/null)
					gtkBackground=$(echo "$gtkBackgroundFull" | awk -F"/" '{print $NF}')
				elif [ -a ${XDG_CONFIG_HOME:-${HOME}/.config}/nitrogen/bg-saved.cfg ]; then
					gtkBackground=$(awk -F"/" '/file=/ {print $NF}' ${XDG_CONFIG_HOME:-${HOME}/.config}/nitrogen/bg-saved.cfg)
				fi
			fi
		;;
	esac
	if [[ "$verbosity" -eq "1" ]]; then
		verboseOut "Finding GTK theme...found as '$gtkTheme'"
		verboseOut "Finding icon theme...found as '$gtkIcons'"
		verboseOut "Finding user font...found as '$gtkFont'"
		[[ $gtkBackground ]] && verboseOut "Finding background...found as '$gtkBackground'"
	fi
}
# GTK Theme\Icon\Font Detection - END


#######################
# End Detection Phase
#######################

takeShot () {
	if [[ -z $screenCommand ]]; then
		if [[ "$hostshot" == "1" ]]; then
			scrot -cd3 "${shotfile}"
			if [ -f "${shotfile}" ]; then
				[[ "$verbosity" -eq "1" ]] && verboseOut "Screenshot saved at '${shotfile}'"
				scp -qo ConnectTimeout="${scptimeout}" "${shotfile}" "${serveraddr}:${serverdir}"
				echo -e "${bold}==>${c0} Your screenshot can be viewed at ${baseurl}/$shotfile"
			else
				verboseOut "ERROR: Problem saving screenshot to ${shotfile}"
			fi
		else
			scrot -cd3 "${shotfile}"
			if [ -f "${shotfile}" ]; then
				[[ "$verbosity" -eq "1" ]] && verboseOut "Screenshot saved at '${shotfile}'"
			else
				verboseOut "ERROR: Problem saving screenshot to ${shotfile}"
			fi
		fi
	else
		$screenCommand
	fi
}



asciiText () {
# Distro logos and ASCII outputs
	case $distro in
		"Arch Linux - Old")
			[ -z $c1 ] && c1="\e[1;37m" # White
			c2="\e[1;34m" # Light Blue
			startline="0"
			fulloutput=("$c1              __                      %s"
"$c1          _=(SDGJT=_                 %s"
"$c1        _GTDJHGGFCVS)                %s"
"$c1       ,GTDJGGDTDFBGX0               %s"
"$c1      JDJDIJHRORVFSBSVL$c2-=+=,_        %s"
"$c1     IJFDUFHJNXIXCDXDSV,$c2  \"DEBL      %s"
"$c1    [LKDSDJTDU=OUSCSBFLD.$c2   '?ZWX,   %s"
"$c1   ,LMDSDSWH'     \`DCBOSI$c2     DRDS], %s"
"$c1   SDDFDFH'         !YEWD,$c2   )HDROD  %s"
"$c1  !KMDOCG            &GSU|$c2\_GFHRGO\'  %s"
"$c1  HKLSGP'$c2           __$c1\TKM0$c2\GHRBV)'  %s"
"$c1 JSNRVW'$c2       __+MNAEC$c1\IOI,$c2\BN'     %s"
"$c1 HELK['$c2    __,=OFFXCBGHC$c1\FD)         %s"
"$c1 ?KGHE $c2\_-#DASDFLSV='$c1    'EF         %s"
"$c1 'EHTI                    !H         %s"
"$c1  \`0F'                    '!")
		;;

		"Arch Linux")
			[ -z $c1 ] && c1="\e[1;36m" # Light
			c2="\e[0;36m" # Dark
			startline="1"
			fulloutput=("${c1}                   -\`"
"${c1}                  .o+\`                %s"
"${c1}                 \`ooo/               %s"
"${c1}                \`+oooo:              %s"
"${c1}               \`+oooooo:             %s"
"${c1}               -+oooooo+:            %s"
"${c1}             \`/:-:++oooo+:           %s"
"${c1}            \`/++++/+++++++:          %s"
"${c1}           \`/++++++++++++++:         %s"
"${c1}          \`/+++o"${c2}"oooooooo"${c1}"oooo/\`       %s"
"${c2}         "${c1}"./"${c2}"ooosssso++osssssso"${c1}"+\`      %s"
"${c2}        .oossssso-\`\`\`\`/ossssss+\`     %s"
"${c2}       -osssssso.      :ssssssso.    %s"
"${c2}      :osssssss/        osssso+++.   %s"
"${c2}     /ossssssss/        +ssssooo/-   %s"
"${c2}   \`/ossssso+/:-        -:/+osssso+- %s"
"${c2}  \`+sso+:-\`                 \`.-/+oso:"
"${c2} \`++:.                           \`-/+/"
"${c2} .\`                                 \`/")
		;;

		"Mint")
			[ -z $c1 ] && c1="\e[1;37m" # White
			c2="\e[1;32m" # Bold Green
			startline="0"
			fulloutput=("$c2 MMMMMMMMMMMMMMMMMMMMMMMMMmds+.        %s"
"$c2 MMm----::-://////////////oymNMd+\`    %s"
"$c2 MMd      "$c1"/++                "$c2"-sNMd:   %s"
"$c2 MMNso/\`  "$c1"dMM    \`.::-. .-::.\` "$c2".hMN:  %s"
"$c2 ddddMMh  "$c1"dMM   :hNMNMNhNMNMNh: "$c2"\`NMm  %s"
"$c2     NMm  "$c1"dMM  .NMN/-+MMM+-/NMN\` "$c2"dMM  %s"
"$c2     NMm  "$c1"dMM  -MMm  \`MMM   dMM. "$c2"dMM  %s"
"$c2     NMm  "$c1"dMM  -MMm  \`MMM   dMM. "$c2"dMM  %s"
"$c2     NMm  "$c1"dMM  .mmd  \`mmm   yMM. "$c2"dMM  %s"
"$c2     NMm  "$c1"dMM\`  ..\`   ...   ydm. "$c2"dMM  %s"
"$c2     hMM- "$c1"+MMd/-------...-:sdds  "$c2"dMM  %s"
"$c2     -NMm- "$c1":hNMNNNmdddddddddy/\`  "$c2"dMM  %s"
"$c2      -dMNs-"$c1"\`\`-::::-------.\`\`    "$c2"dMM  %s"
"$c2       \`/dMNmy+/:-------------:/yMMM  %s"
"$c2          ./ydNMMMMMMMMMMMMMMMMMMMMM  %s")
		;;


		"LMDE")
			[ -z $c1 ] && c1="\e[1;37m" # White
			c2="\e[1;32m" # Bold Green
			startline="1"
			fulloutput=("          "${c1}"\`.-::---.."
"${c2}       .:++++ooooosssoo:.       %s"
"${c2}     .+o++::.      \`.:oos+.    %s"
"${c2}    :oo:.\`             -+oo"${c1}":   %s"
"${c2}  "${c1}"\`"${c2}"+o/\`    ."${c1}"::::::"${c2}"-.    .++-"${c1}"\`  %s"
"${c2} "${c1}"\`"${c2}"/s/    .yyyyyyyyyyo:   +o-"${c1}"\`  %s"
"${c2} "${c1}"\`"${c2}"so     .ss       ohyo\` :s-"${c1}":  %s"
"${c2} "${c1}"\`"${c2}"s/     .ss  h  m  myy/ /s\`"${c1}"\`  %s"
"${c2} \`s:     \`oo  s  m  Myy+-o:\`   %s"
"${c2} \`oo      :+sdoohyoydyso/.     %s"
"${c2}  :o.      .:////////++:       %s"
"${c2}  \`/++        "${c1}"-:::::-          %s"
"${c2}   "${c1}"\`"${c2}"++-                        %s"
"${c2}    "${c1}"\`"${c2}"/+-                       %s"
"${c2}      "${c1}"."${c2}"+/.                     %s"
"${c2}        "${c1}"."${c2}":+-.                  %s"
"${c2}           \`--.\`\`")
		;;

		"Ubuntu")
			[ -z $c1 ] && c1="\e[1;37m" # White
			c2="\e[1;31m" # Light Red
			c3="\e[1;33m" # Bold Yellow
			startline="1"
			fulloutput=("$c2                          ./+o+-"
"$c1                  yyyyy- $c2-yyyyyy+      %s"
"$c1               $c1://+//////$c2-yyyyyyo     %s"
"$c3           .++ $c1.:/++++++/-$c2.+sss/\`     %s"
"$c3         .:++o:  $c1/++++++++/:--:/-     %s"
"$c3        o:+o+:++.$c1\`..\`\`\`.-/oo+++++/    %s"
"$c3       .:+o:+o/.$c1          \`+sssoo+/   %s"
"$c1  .++/+:$c3+oo+o:\`$c1             /sssooo.  %s"
"$c1 /+++//+:$c3\`oo+o$c1               /::--:.  %s"
"$c1 \+/+o+++$c3\`o++o$c2               ++////.  %s"
"$c1  .++.o+$c3++oo+:\`$c2             /dddhhh.  %s"
"$c3       .+.o+oo:.$c2          \`oddhhhh+   $mygtk"
"$c3        \+.++o+o\`\`-\`\`$c2\`\`.:ohdhhhhh+    %s"
"$c3         \`:o+++ $c2\`ohhhhhhhhyo++os:     %s"
"$c3           .o:$c2\`.syhhhhhhh/$c3.oo++o\`     %s"
"$c2               /osyyyyyyo$c3++ooo+++/    %s"
"$c2                   \`\`\`\`\` $c3+oo+++o\:"
"$c3                          \`oo++.")
		;;

		"Debian")
			[ -z $c1 ] && c1="\e[1;37m" # White
			c2="\e[1;31m" # Light Red
			startline="1"
			fulloutput=("  $c1       _,met\$\$\$\$\$gg."
"  $c1    ,g\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$P.\t %s"
"  $c1  ,g\$\$P\"\"       \"\"\"Y\$\$.\".\t%s"
"  $c1 ,\$\$P'              \`\$\$\$.\t%s"
"  $c1',\$\$P       ,ggs.     \`\$\$b:\t%s"
"  $c1\`d\$\$'     ,\$P\"\'   $c2.$c1    \$\$\$\t%s"
"  $c1 \$\$P      d\$\'     $c2,$c1    \$\$P\t%s"
"  $c1 \$\$:      \$\$.   $c2-$c1    ,d\$\$'\t%s"
"  $c1 \$\$\;      Y\$b._   _,d\$P'\t%s"
"  $c1 Y\$\$.    $c2\`.$c1\`\"Y\$\$\$\$P\"'\t\t%s"
"  $c1 \`\$\$b      $c2\"-.__\t\t%s"
"  $c1  \`Y\$\$\t\t\t%s"
"  $c1   \`Y\$\$.\t\t\t%s"
"  $c1     \`\$\$b.\t\t\t%s"
"  $c1       \`Y\$\$b.\t\t\t%s"
"  $c1          \`\"Y\$b._\t\t%s"
"  $c1              \`\"\"\"\"")
		;;

		"CrunchBang")
			[ -z $c1 ] && c1="\e[1;37m" # White
			c2="\e[1;30m" # Dark Gray
			startline="1"
			fulloutput=("$c1                 ___       ___     _"
"$c1                /  /      /  /    | |  %s"
"$c1               /  /      /  /     | | %s"
"$c1              /  /      /  /      | | %s"
"$c1             /  /      /  /       | | %s"
"$c1     _______/  /______/  /______  | | %s"
"$c1    /______   _______   _______/  | | %s"
"$c1          /  /      /  /          | | %s"
"$c1         /  /      /  /           | | %s"
"$c1        /  /      /  /            | | %s"
"$c1 ______/  /______/  /______       | | %s"
"$c1/_____   _______   _______/       | | %s"
"$c1     /  /      /  /               | | %s"
"$c1    /  /      /  /                |_| %s"
"$c1   /  /      /  /                  _  %s"
"$c1  /  /      /  /                  | | %s"
"$c1 /__/      /__/                   |_| %s")
		;;

		"Gentoo")
			[ -z $c1 ] && c1="\e[1;37m" # White
			c2="\e[1;35m" # Light Purple
			startline="2"
			fulloutput=("$c2         -/oyddmdhs+:."
"$c2     -o"$c1"dNMMMMMMMMNNmhy+"$c2"-\`"
"$c2   -y"$c1"NMMMMMMMMMMMNNNmmdhy"$c2"+-           %s"
"$c2 \`o"$c1"mMMMMMMMMMMMMNmdmmmmddhhy"$c2"/\`       %s"
"$c2 om"$c1"MMMMMMMMMMMN"$c2"hhyyyo"$c1"hmdddhhhd"$c2"o\`     %s"
"$c2.y"$c1"dMMMMMMMMMMd"$c2"hs++so/s"$c1"mdddhhhhdm"$c2"+\`   %s"
"$c2 oy"$c1"hdmNMMMMMMMN"$c2"dyooy"$c1"dmddddhhhhyhN"$c2"d.  %s"
"$c2  :o"$c1"yhhdNNMMMMMMMNNNmmdddhhhhhyym"$c2"Mh  %s"
"$c2    .:"$c1"+sydNMMMMMNNNmmmdddhhhhhhmM"$c2"my  %s"
"$c2       /m"$c1"MMMMMMNNNmmmdddhhhhhmMNh"$c2"s:  %s"
"$c2    \`o"$c1"NMMMMMMMNNNmmmddddhhdmMNhs"$c2"+\`   %s"
"$c2  \`s"$c1"NMMMMMMMMNNNmmmdddddmNMmhs"$c2"/.     %s"
"$c2 /N"$c1"MMMMMMMMNNNNmmmdddmNMNdso"$c2":\`       %s"
"$c2+M"$c1"MMMMMMNNNNNmmmmdmNMNdso"$c2"/-          %s"
"$c2yM"$c1"MNNNNNNNmmmmmNNMmhs+/"$c2"-\`              %s"
"$c2/h"$c1"MMNNNNNNNNMNdhs++/"$c2"-\`"
"$c2\`/"$c1"ohdmmddhys+++/:"$c2".\`"
"$c2  \`-//////:--.")
		;;

		"Fedora")
			[ -z $c1 ] && c1="\e[1;37m" # White
			c2="\e[1;34m" # Light Blue
			startline="1"
			fulloutput=("$c2           :/------------://"
"$c2        :------------------://        %s"
"$c2      :-----------"$c1"/shhdhyo/"$c2"-://      %s"
"$c2    /-----------"$c1"omMMMNNNMMMd/"$c2"-:/     %s"
"$c2   :-----------"$c1"sMMMdo:/"$c2"       -:/    %s"
"$c2  :-----------"$c1":MMMd"$c2"-------    --:/   %s"
"$c2  /-----------"$c1":MMMy"$c2"-------    ---/   %s"
"$c2 :------    --"$c1"/+MMMh/"$c2"--        ---:  %s"
"$c2 :---     "$c1"oNMMMMMMMMMNho"$c2"     -----:  %s"
"$c2 :--      "$c1"+shhhMMMmhhy++"$c2"   ------:   %s"
"$c2 :-      -----"$c1":MMMy"$c2"--------------/   %s"
"$c2 :-     ------"$c1"/MMMy"$c2"-------------:    %s"
"$c2 :-      ----"$c1"/hMMM+"$c2"------------:     %s"
"$c2 :--"$c1":dMMNdhhdNMMNo"$c2"-----------:       %s"
"$c2 :---"$c1":sdNMMMMNds:"$c2"----------:         %s"
"$c2 :------"$c1":://:"$c2"-----------://          %s"
"$c2 :--------------------://")
		;;

		"BSD")
			[ -z $c1 ] && c1="\e[1;37m" # White
			c2="\e[1;31m" # Light Red
			startline="2"
			fulloutput=("$c2              ,        ,"
"$c2             /(        )\`"
"$c2             \ \___   / |          %s"
"$c2             /- "$c1"_$c2  \`-/  '         %s"
"$c2            ($c1/\/ \ $c2\   /\\         %s"
"$c1            / /   |$c2 \`    \\        %s"
"$c1            O O   )$c2 /    |        %s"
"$c1            \`-^--'\`$c2<     '        %s"
"$c2           (_.)  _  )   /         %s"
"$c2            \`.___/\`    /          %s"
"$c2              \`-----' /           %s"
"$c1 <----.     "$c2"__/ __   \\            %s"
"$c1 <----|===="$c2"O}}}$c1==$c2} \} \/$c1====      %s"
"$c1 <----'    $c2\`--' \`.__,' \\          %s"
"$c2              |        |          %s"
"$c2               \       /       /\\ %s"
"$c2          ______( (_  / \______/  %s"
"$c2        ,'  ,-----'   |"
"$c2        \`--{__________)")
		;;

		"Mandriva"|"Mandrake")
			c1="\e[1;34m" # Light Blue
			c2="\e[1;33m" # Bold Yellow
			startline="0"
			fulloutput=("$c2                         \`\`               %s"
"$c2                        \`-.              %s"
"$c1       \`               $c2.---              %s"
"$c1     -/               $c2-::--\`             %s"
"$c1   \`++    $c2\`----...\`\`\`-:::::.             %s"
"$c1  \`os.      $c2.::::::::::::::-\`\`\`     \`  \` %s"
"$c1  +s+         $c2.::::::::::::::::---...--\` %s"
"$c1 -ss:          $c2\`-::::::::::::::::-.\`\`.\`\` %s"
"$c1 /ss-           $c2.::::::::::::-.\`\`   \`    %s"
"$c1 +ss:          $c2.::::::::::::-            %s"
"$c1 /sso         $c2.::::::-::::::-            %s"
"$c1 .sss/       $c2-:::-.\`   .:::::            %s"
"$c1  /sss+.    $c2..\`$c1  \`--\`    $c2.:::            %s"
"$c1   -ossso+/:://+/-\`        $c2.:\`           %s"
"$c1     -/+ooo+/-.              $c2\`           %s")
		;;

		"openSUSE")
			c1="\e[1;32m" # Bold Green
			c2="\e[1;37m" # Bold White
			startline="2"
			fulloutput=("$c2             .;ldkO0000Okdl;."
"$c2         .;d00xl:,'....';:ok00d;."
"$c2       .d00l'                ,o00d.          %s"
"$c2     .d0Kd."$c1" :Okxol:;'.          "$c2":O0d.       %s"
"$c2    'OK"$c1"KKK0kOKKKKKKKKKKOxo:'      "$c2"lKO'      %s"
"$c2   ,0K"$c1"KKKKKKKKKKKKKKK0d:"$c2",,,"$c1":dx:"$c2"    ;00,     %s"
"$c2  .OK"$c1"KKKKKKKKKKKKKKKk."$c2".oOkdl."$c1"'0k."$c2"   cKO.    %s"
"$c2  :KK"$c1"KKKKKKKKKKKKKKK: "$c2"kKx..od "$c1"lKd"$c2"   .OK:    %s"
"$c2  dKK"$c1"KKKKKKKKKOx0KKKd "$c2";0KKKO, "$c1"kKKc"$c2"   dKd    %s"
"$c2  dKK"$c1"KKKKKKKKKK;.;oOKx,.."$c2"'"$c1"..;kKKK0."$c2"  dKd    %s"
"$c2  :KK"$c1"KKKKKKKKKK0o;...;cdxxOK0Oxc,.  "$c2".0K:    %s"
"$c2   kKK"$c1"KKKKKKKKKKKKK0xl;'......,cdo  "$c2"lKk     %s"
"$c2   '0K"$c1"KKKKKKKKKKKKKKKKKKKK00KKOo;  "$c2"c00'     %s"
"$c2    .kK"$c1"KKOxddxkOO00000Okxoc;'.   "$c2".dKk.      %s"
"$c2      l0Ko.                    .c00l.       %s"
"$c2       .l0Kk:.              .;xK0l.         %s"
"$c2          ,lkK0xl:;,,,,;:ldO0kl,            %s"
"$c2              .':ldxkkkkxdl:'.")
		;;

		"Slackware")
			[ -z $c1 ] && c1="\e[1;34m" # Light Blue
			c2="\e[1;37m" # Bold White
			startline="3"
			fulloutput=("$c1                   :::::::"
"$c1             :::::::::::::::::::"
"$c1          :::::::::::::::::::::::::"
"$c1        ::::::::"${c2}"cllcccccllllllll"${c1}"::::::         %s"
"$c1     :::::::::"${c2}"lc               dc"${c1}":::::::      %s"
"$c1    ::::::::"${c2}"cl   clllccllll    oc"${c1}":::::::::    %s"
"$c1   :::::::::"${c2}"o   lc"${c1}"::::::::"${c2}"co   oc"${c1}"::::::::::   %s"
"$c1  ::::::::::"${c2}"o    cccclc"${c1}":::::"${c2}"clcc"${c1}"::::::::::::  %s"
"$c1  :::::::::::"${c2}"lc        cclccclc"${c1}":::::::::::::  %s"
"$c1 ::::::::::::::"${c2}"lcclcc          lc"${c1}":::::::::::: %s"
"$c1 ::::::::::"${c2}"cclcc"${c1}":::::"${c2}"lccclc     oc"${c1}"::::::::::: %s"
"$c1 ::::::::::"${c2}"o    l"${c1}"::::::::::"${c2}"l    lc"${c1}"::::::::::: %s"
"$c1  :::::"${c2}"cll"${c1}":"${c2}"o     clcllcccll     o"${c1}":::::::::::  %s"
"$c1  :::::"${c2}"occ"${c1}":"${c2}"o                  clc"${c1}":::::::::::  %s"
"$c1   ::::"${c2}"ocl"${c1}":"${c2}"ccslclccclclccclclc"${c1}":::::::::::::   %s"
"$c1    :::"${c2}"oclcccccccccccccllllllllllllll"${c1}":::::    %s"
"$c1     ::"${c2}"lcc1lcccccccccccccccccccccccco"${c1}"::::     %s"
"$c1       ::::::::::::::::::::::::::::::::       %s"
"$c1         ::::::::::::::::::::::::::::"
"$c1            ::::::::::::::::::::::"
"$c1                 ::::::::::::")
		;;

		"Red Hat Linux")
			[ -z $c1 ] && c1="\e[1;37m" # White
			c2="\e[1;31m" # Light Red
			startline="0"
			fulloutput=("$c2              \`.-..........\`               %s"
"$c2             \`////////::.\`-/.             %s"
"$c2             -: ....-////////.            %s"
"$c2             //:-::///////////\`           %s"
"$c2      \`--::: \`-://////////////:           %s"
"$c2      //////-    \`\`.-:///////// .\`        %s"
"$c2      \`://////:-.\`    :///////::///:\`     %s"
"$c2        .-/////////:---/////////////:     %s"
"$c2           .-://////////////////////.     %s"
"$c1          yMN+\`.-$c2::///////////////-\`      %s"
"$c1       .-\`:NMMNMs\`  \`..-------..\`         %s"
"$c1        MN+/mMMMMMhoooyysshsss            %s"
"$c1 MMM    MMMMMMMMMMMMMMyyddMMM+            %s"
"$c1  MMMM   MMMMMMMMMMMMMNdyNMMh\`     hyhMMM %s"
"$c1   MMMMMMMMMMMMMMMMyoNNNMMM+.   MMMMMMMM  %s"
"$c1    MMNMMMNNMMMMMNM+ mhsMNyyyyMNMMMMsMM")
		;;

		"Frugalware")
			[ -z $c1 ] && c1="\e[1;37m" # White
			c2="\e[1;36m" # Light Blue
			startline="5"
			fulloutput=("${c2}          \`++/::-.\`"
"${c2}         /o+++++++++/::-.\`"
"${c2}        \`o+++++++++++++++o++/::-.\`"
"${c2}        /+++++++++++++++++++++++oo++/:-.\`\`"
"${c2}       .o+ooooooooooooooooooosssssssso++oo++/:-\`"
"${c2}       ++osoooooooooooosssssssssssssyyo+++++++o:   %s"
"${c2}      -o+ssoooooooooooosssssssssssssyyo+++++++s\`  %s"
"${c2}      o++ssoooooo++++++++++++++sssyyyyo++++++o:   %s"
"${c2}     :o++ssoooooo"${c1}"/-------------"${c2}"+syyyyyo+++++oo    %s"
"${c2}    \`o+++ssoooooo"${c1}"/-----"${c2}"+++++ooosyyyyyyo++++os:    %s"
"${c2}    /o+++ssoooooo"${c1}"/-----"${c2}"ooooooosyyyyyyyo+oooss     %s"
"${c2}   .o++++ssooooos"${c1}"/------------"${c2}"syyyyyyhsosssy-     %s"
"${c2}   ++++++ssooooss"${c1}"/-----"${c2}"+++++ooyyhhhhhdssssso      %s"
"${c2}  -s+++++syssssss"${c1}"/-----"${c2}"yyhhhhhhhhhhhddssssy.      %s"
"${c2}  sooooooyhyyyyyh"${c1}"/-----"${c2}"hhhhhhhhhhhddddyssy+       %s"
"${c2} :yooooooyhyyyhhhyyyyyyhhhhhhhhhhdddddyssy\`       %s"
"${c2} yoooooooyhyyhhhhhhhhhhhhhhhhhhhddddddysy/        %s"
"${c2}-ysooooooydhhhhhhhhhhhddddddddddddddddssy         %s"
"${c2} .-:/+osssyyyysyyyyyyyyyyyyyyyyyyyyyyssy:         %s"
"${c2}       \`\`.-/+oosysssssssssssssssssssssss          %s"
"${c2}               \`\`.:/+osyysssssssssssssh."
"${c2}                        \`-:/+osyyssssyo"
"${c2}                                .-:+++\`")
		;;


		"Peppermint")
			[ -z $c1 ] && c1="\e[1;37m" # White
			c2="\e[1;31m" # Light Red
			startline="2"
			fulloutput=("${c2}             8ZZZZZZ"${c1}"MMMMM"
"${c2}          .ZZZZZZZZZ"${c1}"MMMMMMM."
"${c1}        MM"${c2}"ZZZZZZZZZ"${c1}"MMMMMMM"${c2}"ZZZZ          %s"
"${c1}      MMMMM"${c2}"ZZZZZZZZ"${c1}"MMMMM"${c2}"ZZZZZZZM       %s"
"${c1}     MMMMMMM"${c2}"ZZZZZZZ"${c1}"MMMM"${c2}"ZZZZZZZZZ.      %s"
"${c1}    MMMMMMMMM"${c2}"ZZZZZZ"${c1}"MMM"${c2}"ZZZZZZZZZZZI     %s"
"${c1}   MMMMMMMMMMM"${c2}"ZZZZZZ"${c1}"MM"${c2}"ZZZZZZZZZZ"${c1}"MMM    %s"
"${c2}   .ZZZ"${c1}"MMMMMMMMMM"${c2}"IZZ"${c1}"MM"${c2}"ZZZZZ"${c1}"MMMMMMMMM   %s"    
"${c2}   ZZZZZZZ"${c1}"MMMMMMMM"${c2}"ZZ"${c1}"M"${c2}"ZZZZ"${c1}"MMMMMMMMMMM   %s"
"${c2}   ZZZZZZZZZZZZZZZZ"${c1}"M"${c2}"Z"${c1}"MMMMMMMMMMMMMMM   %s"
"${c2}   .ZZZZZZZZZZZZZ"${c1}"MMM"${c2}"Z"${c1}"M"${c2}"ZZZZZZZZZZ"${c1}"MMMM   %s"
"${c2}   .ZZZZZZZZZZZ"${c1}"MMM"${c2}"7ZZ"${c1}"MM"${c2}"ZZZZZZZZZZ7"${c1}"M    %s"
"${c2}    ZZZZZZZZZ"${c1}"MMMM"${c2}"ZZZZ"${c1}"MMMM"${c2}"ZZZZZZZ77     %s"
"${c1}     MMMMMMMMMMMM"${c2}"ZZZZZ"${c1}"MMMM"${c2}"ZZZZZ77      %s"
"${c1}      MMMMMMMMMM"${c2}"7ZZZZZZ"${c1}"MMMMM"${c2}"ZZ77       %s"
"${c1}       .MMMMMMM"${c2}"ZZZZZZZZ"${c1}"MMMMM"${c2}"Z7Z        %s"
"${c1}         MMMMM"${c2}"ZZZZZZZZZ"${c1}"MMMMMMM         %s"
"${c2}           NZZZZZZZZZZZ"${c1}"MMMMM"
"${c2}              ZZZZZZZZZ"${c1}"MM")
		;;

		"SolusOS")
			[ -z $c1 ] && c1="\e[1;37m" # White
			c2="\e[1;30m" # Light Gray
			startline="2"
			fulloutput=("${c1}               e         e"
"${c1}             eee       ee"
"${c1}            eeee     eee        %s"
"${c2}        wwwwwwwww"${c1}"eeeeee        %s"
"${c2}     wwwwwwwwwwwwwww"${c1}"eee        %s"
"${c2}   wwwwwwwwwwwwwwwwwww"${c1}"eeeeeeee %s"
"${c2}  wwwww     "${c1}"eeeee"${c2}"wwwwww"${c1}"eeee    %s"
"${c2} www          "${c1}"eeee"${c2}"wwwwww"${c1}"e      %s"
"${c2} ww             "${c1}"ee"${c2}"wwwwww       %s"
"${c2} w                 wwwww       %s"
"${c2}                   wwwww       %s"
"${c2}                  wwwww        %s"
"${c2}                 wwwww         %s"
"${c2}                wwww           %s"
"${c2}               wwww            %s"
"${c2}             wwww              %s"
"${c2}           www                 %s"
"${c2}         ww")
		;;



		"Mageia")
			[ -z $c1 ] && c1="\e[1;34m" # Light Blue
			c2="\e[0;36m" # Light Cyan
			startline="2"
			fulloutput=("$c2             .''   "
"$c2              '.     ..           "
"$c2                    .,,.          %s"
"$c2                 ,;;.            %s"
"$c2                 ... ...         %s"
"$c2              ',,'  .:::.        %s"
"$c1            .$c2,:c,$c1    .. .        %s"
"$c1          :dkxc;'.  ..,cxkd;     %s"
"$c1        .dkkxxkkkkkkkkkkxxkkd.   %s"
"$c1       .dkko. ';cloolc;. .dkkd   %s"
"$c1       ckkx.              .xkk;  %s"
"$c1       xOO:                cOOd  %s"
"$c1       xOO:                lOOd  %s"
"$c1       lOOx.              .kOO:  %s"
"$c1       .k00d.            .x00x   %s"
"$c1        .k00O;          ;k00O.   %s"
"$c1         .lO0KOdc;,,;cdO0KOc.    %s"
"$c1            ;d0KKKKKKKK0d;         "
"$c1               .,;::;,.            ")
		;;

		*)
			[ -z $c1 ] && c1="\e[1;37m" # White
			c2="\e[1;30m" # Light Gray
			c3="\e[1;33m" # Light Yellow
			startline="0"
			fulloutput=("                             %s"
"                            %s"
"$c2         #####$c0              %s"
"$c2        #######             %s"
"$c2        ##"$c1"O$c2#"$c1"O$c2##             %s"
"$c2        #$c3#####$c2#             %s"
"$c2      ##$c1##$c3###$c1##$c2##           %s"
"$c2     #$c1##########$c2##          %s"
"$c2    #$c1############$c2##         %s"
"$c2    #$c1############$c2###        %s"
"$c3   ##$c2#$c1###########$c2##$c3#        %s"
"$c3 ######$c2#$c1#######$c2#$c3######      %s"
"$c3 #######$c2#$c1#####$c2#$c3#######      %s"
"$c3   #####$c2#######$c3#####        %s"
"                            %s"
"$c0")
  		;;
	esac

	# Truncate lines based on terminal width.
	if [ "$truncateSet" == "Yes" ]; then
		n=${#fulloutput[*]}
		for ((i=0;i<n;i++)); do
			targetPercent=100
			termWidth=$(tput cols)
			# stringReal=$(echo "${fulloutput[i]}" | sed -e 's/\x1b\[[0-9];[0-9]*m\?//g')
			stringReal=$(echo "${fulloutput[i]}" | sed -e 's/\\e\[[0-9];[0-9]*m//g' -e 's/\\e\[[0-9]*m//g')
			stringLength=${#stringReal}
			targetLength="$((termWidth*targetPercent/100))"
			if [ "$stringLength" -le "$targetLength" ]; then
				echo -e "${fulloutput[i]}"$c0
			elif [ "$stringLength" -gt "$targetLength" ]; then
			 	echo "${fulloutput[i]:0:$targetLength}..."$c0
			fi
			# Debugging widths
			# echo "Term Width: $termWidth"
			# echo "String Length: $stringLength"
		done
	else
		n=${#fulloutput[*]}
		for ((i=0;i<n;i++)); do
			# echo "${out_array[@]}"
			printf "${fulloutput[i]}$c0\n" "${out_array}"
			if [[ "$i" -ge "$startline" ]]; then
				unset out_array[0]
				out_array=( "${out_array[@]}" )
			fi
		done
	fi
	# Done with ASCII output
}

infoDisplay () {
	if [ -z "$textcolor" ]; then textcolor="\e[0m"; fi
	#TODO: Centralize colors and use them across the board so we only change them one place.
	if [ -z "$labelcolor" ]; then
		case $distro in
			"Arch Linux - Old"|"Fedora"|"Mandriva"|"Mandrake") labelcolor="\e[1;34m";;
			"Arch Linux"|"Frugalware"|"Mageia") labelcolor="\e[1;36m";;
			"Mint"|"LMDE"|"openSUSE") labelcolor="\e[1;32m";;
			"Ubuntu"|"Debian"|"BSD"|"Red Hat Linux"|"Peppermint") labelcolor="\e[1;31m";;
			"CrunchBang"|"SolusOS") labelcolor="\e[1;30m";;
			"Gentoo") labelcolor="\e[1;35m";;
			"Slackware") labelcolor="\e[1;34m";;
			*) labelcolor="\e[1;33m";;
		esac 
	fi
	# Some verbosity stuff
	[[ "$verbosity" == "1" ]] && [[ "$screenshot" == "1" ]] && verboseOut "Screenshot will be taken after info is displayed."
	[[ "$verbosity" == "1" ]] && [[ "$hostshot" == "1" ]] && verboseOut "Screenshot will be transferred/uploaded to specified location."
	#########################
	# Info Variable Setting #
	#########################
	if [[ "${display[@]}" =~ "host" ]]; then myinfo=$(echo -e "${labelcolor}${myUser}$textcolor$bold@${labelcolor}${myHost}"); out_array=( "${out_array[@]}" "$myinfo" ); ((display_index++)); fi
	if [[ "${display[@]}" =~ "distro" ]]; then
		sysArch=`uname -m`
		if [ -n "$distro_more" ]; then mydistro=$(echo -e "$labelcolor OS:$textcolor $distro_more $sysArch")
		else mydistro=$(echo -e "$labelcolor OS:$textcolor $distro $sysArch"); fi
		out_array=( "${out_array[@]}" "$mydistro" )
		((display_index++))
	fi
	if [[ "${display[@]}" =~ "kernel" ]]; then mykernel=$(echo -e "$labelcolor Kernel:$textcolor $kernel"); out_array=( "${out_array[@]}" "$mykernel" ); ((display_index++)); fi
	if [[ "${display[@]}" =~ "uptime" ]]; then myuptime=$(echo -e "$labelcolor Uptime:$textcolor $uptime"); out_array=( "${out_array[@]}" "$myuptime" ); ((display_index++)); fi
	if [[ "${display[@]}" =~ "pkgs" ]]; then mypkgs=$(echo -e "$labelcolor Packages:$textcolor $pkgs"); out_array=( "${out_array[@]}" "$mypkgs" ); ((display_index++)); fi
	if [[ "${display[@]}" =~ "shell" ]]; then myshell=$(echo -e "$labelcolor Shell:$textcolor $myShell"); out_array=( "${out_array[@]}" "$myshell" ); ((display_index++)); fi
	if [[ "${display[@]}" =~ "res" ]]; then myres=$(echo -e "$labelcolor Resolution:${textcolor} $xResolution"); out_array=( "${out_array[@]}" "$myres" ); ((display_index++)); fi
	if [[ "${display[@]}" =~ "de" ]]; then myde=$(echo -e "$labelcolor DE:$textcolor $DE"); out_array=( "${out_array[@]}" "$myde" ); ((display_index++)); fi
	if [[ "${display[@]}" =~ "wm" ]]; then mywm=$(echo -e "$labelcolor WM:$textcolor $WM"); out_array=( "${out_array[@]}" "$mywm" ); ((display_index++)); fi
	if [[ "${display[@]}" =~ "wmtheme" ]]; then mywmtheme=$(echo -e "$labelcolor WM Theme:$textcolor $Win_theme"); out_array=( "${out_array[@]}" "$mywmtheme" ); ((display_index++)); fi
	if [[ "${display[@]}" =~ "gtk" ]]; then 
		mygtk=$(echo -e "$labelcolor GTK Theme:$textcolor $gtkTheme"); out_array=( "${out_array[@]}" "$mygtk" ); ((display_index++))
		myicons=$(echo -e "$labelcolor Icon Theme:$textcolor $gtkIcons"); out_array=( "${out_array[@]}" "$myicons" ); ((display_index++))
		myfont=$(echo -e "$labelcolor Font:$textcolor $gtkFont"); out_array=( "${out_array[@]}" "$myfont" ); ((display_index++))
		# [ "$gtkBackground" ] && mybg=$(echo -e "$labelcolor BG:$textcolor $gtkBackground"); out_array=( "${out_array[@]}" "$mybg" ); ((display_index++))
	fi
	if [[ "${display[@]}" =~ "cpu" ]]; then mycpu=$(echo -e "$labelcolor CPU:$textcolor $cpu"); out_array=( "${out_array[@]}" "$mycpu" ); ((display_index++)); fi
	if [[ "${display[@]}" =~ "mem" ]]; then mymem=$(echo -e "$labelcolor RAM:$textcolor $mem"); out_array=( "${out_array[@]}" "$mymem" ); ((display_index++)); fi
	if [[ "$display_type" == "ASCII" ]]; then
		asciiText
	else
		echo -e "$mydistro" 
		echo -e "$mykernel"
		echo -e "$myuptime"
		echo -e "$myshell"
		echo -e "$myres"
		echo -e "$myde"
		echo -e "$mywm"
		echo -e "$mywmtheme"
		echo -e "$mygtk"
		echo -e "$myicons"
		echo -e "$myfont"
	fi
}

########
# Theme Exporting (Experimental!)
########
themeExport () {
	WM=$(echo "$mywm" | awk '{print $NF}')
	if [[ ! -d /tmp/screenfetch-export ]]; then mkdir -p "/tmp/screenfetch-export/Icons" & mkdir -p "/tmp/screenfetch-export/GTK-Theme" & mkdir -p "/tmp/screenfetch-export/WM-${WM}" ; fi
	if [[ "$WM" ]]; then
		if [[ "$WM" =~ "Openbox" ]]; then
			if [[ "$Win_theme" != "Not Found" ]]; then
				if [[ -d "$HOME/.themes/$Win_theme" ]]; then
					cp -r "$HOME/.themes/$Win_theme" "/tmp/screenfetch-export/WM-${WM}/$Win_theme" &>/dev/null
					[[ "$verbosity" -eq "1" ]] && verboseOut "Found WM theme folder. Transferring to /tmp/screenfetch-export/..."
				fi
			fi
		elif [[ "$WM" =~ "Fluxbox" ]]; then
			if [[ "$Win_theme" != "Not Found" ]]; then
				if [[ -d "$HOME/.fluxbox/styles/$Win_theme" ]]; then
					cp -r "$HOME/.fluxbox/styles/$Win_theme" "/tmp/screenfetch-export/WM-${WM}/$Win_theme" &>/dev/null
					[[ "$verbosity" -eq "1" ]] && verboseOut "Found WM theme folder. Transferring to /tmp/screenfetch-export/..."
				fi
			fi
		elif [[ "$WM" =~ "Blackbox" ]]; then
			if [[ "$Win_theme" != "Not Found" ]]; then
				if [[ -d "$HOME/.blackbox/styles/$Win_theme" ]]; then
					cp -r "$HOME/.blackbox/styles/$Win_theme" "/tmp/screenfetch-export/WM-${WM}/$Win_theme" &>/dev/null
					[[ "$verbosity" -eq "1" ]] && verboseOut "Found WM theme folder. Transferring to /tmp/screenfetch-export/..."
				elif [[ -d "/usr/share/blackbox/styles/$Win_theme" ]]; then
					cp -r "/usr/share/blackbox/styles/$Win_theme" "/tmp/screenfetch-export/WM-${WM}/$Win_theme" &>/dev/null
					[[ "$verbosity" -eq "1" ]] && verboseOut "Found WM theme folder. Transferring to /tmp/screenfetch-export/..."
				fi
			fi
		elif [[ "$WM" =~ "PekWM" ]]; then
			if [[ "$Win_theme" != "Not Found" ]]; then
				if [[ -d "$HOME/.pekwm/themes/$Win_theme" ]]; then
					cp -r "$HOME/.pekwm/themes/$Win_theme" "/tmp/screenfetch-export/WM-${WM}/$Win_theme" &>/dev/null
					[[ "$verbosity" -eq "1" ]] && verboseOut "Found WM theme folder. Transferring to /tmp/screenfetch-export/..."
				fi
			fi
		elif [[ "$WM" =~ "Metacity" ]]; then
			if [[ "$Win_theme" != "Not Found" ]]; then
				if [[ -d "$HOME/.themes/$Win_theme" ]]; then
					cp -r "$HOME/.themes/$Win_theme" "/tmp/screenfetch-export/WM-${WM}/$Win_theme" &>/dev/null
					[[ "$verbosity" -eq "1" ]] && verboseOut "Found WM theme folder. Transferring to /tmp/screenfetch-export/..."
				elif [[ -d "/usr/share/themes/$Win_theme" ]]; then
					cp -r "/usr/share/themes/$Win_theme" "/tmp/screenfetch-export/WM-${WM}/$Win_theme" &>/dev/null
					[[ "$verbosity" -eq "1" ]] && verboseOut "Found WM theme folder. Transferring to /tmp/screenfetch-export/..."
				fi
			fi
		elif [[ "$WM" =~ "Xfwm4" ]]; then
			if [[ "$Win_theme" != "Not Found" ]]; then
				WM_theme=$(echo "$Win_theme" | awk '{print $NF}')
				if [[ -d "$HOME/.themes/$Win_theme" ]]; then
					cp -r "$HOME/.themes/$Win_theme" "/tmp/screenfetch-export/WM-${WM}/$Win_theme" &>/dev/null
					[[ "$verbosity" -eq "1" ]] && verboseOut "Found WM theme folder. Transferring to /tmp/screenfetch-export/..."
				elif [[ -d "/usr/share/themes/$Win_theme" ]]; then
					cp -r "/usr/share/themes/$Win_theme" "/tmp/screenfetch-export/WM-${WM}/$Win_theme" &>/dev/null
					[[ "$verbosity" -eq "1" ]] && verboseOut "Found WM theme folder. Transferring to /tmp/screenfetch-export/..."
				fi
			fi
		fi
	fi
	if [[ "$gtkBackgroundFull" ]]; then
		cp "$gtkBackgroundFull" /tmp/screenfetch-export/
		[[ "$verbosity" -eq "1" ]] && verboseOut "Found BG file. Transferring to /tmp/screenfetch-export/..."
	fi
	if [[ "$mygtk" ]]; then
		GTK_theme=$(echo "$mygtk" | awk '{print $NF}')
		if [ -d "/usr/share/themes/$GTK_theme" ]; then
			cp -r "/usr/share/themes/$GTK_theme" "/tmp/screenfetch-export/GTK/Theme/$GTK_theme" &>/dev/null
			[[ "$verbosity" -eq "1" ]] && verboseOut "Found GTK theme folder. Transferring to /tmp/screenfetch-export/..."
		fi
	fi
	if [[ "$myicons" ]]; then
		GTK_icons=$(echo "$myicons" | awk '{print $NF}')
		if [ -d "/usr/share/icons/$GTK_icons" ]; then
			cp -r "/usr/share/icons/$GTK_icons" "/tmp/screenfetch-export/GTK/Icons/$GTK_icons" &>/dev/null
			[[ "$verbosity" -eq "1" ]] && verboseOut "Found GTK icons theme folder. Transferring to /tmp/screenfetch-export/..."
		fi
		if [ -d "$HOME/.icons/$GTK_icons" ]; then
			cp -r "$HOME/.icons/$GTK_icons" "/tmp/screenfetch-export/GTK/Icons/$GTK_icons" &>/dev/null
			[[ "$verbosity" -eq "1" ]] && verboseOut "Found GTK icons theme folder. Transferring to /tmp/screenfetch-export/..."
		fi
	fi
	if [[ "$myfont" ]]; then
		GTK_font=$(echo "$myfont" | awk '{print $NF}')
		if [ -d "/usr/share/fonts/$GTK_font" ]; then
			cp -r "/usr/share/fonts/$GTK_font" "/tmp/screenfetch-export/GTK/$GTK_font" &>/dev/null
			[[ "$verbosity" -eq "1" ]] && verboseOut "Found GTK font. Transferring to /tmp/screenfetch-export/..."
		elif [ -d "$HOME/.fonts/$GTK_font" ]; then
			cp -r "$HOME/.fonts/$GTK_font" "/tmp/screenfetch-export/GTK/$GTK_font" &>/dev/null
			[[ "$verbosity" -eq "1" ]] && verboseOut "Found GTK font. Transferring to /tmp/screenfetch-export/..."
		fi
	fi
	if [ "$screenshot" == "1" ]; then
		if [ -f "${shotfile}" ]; then
			cp "${shotfile}" "/tmp/screenfetch-export/"
			[[ "$verbosity" -eq "1" ]] && verboseOut "Found screenshot. Transferring to /tmp/screenfetch-export/..."
		fi
	fi
	cd /tmp/screenfetch-export/
	[[ "$verbosity" -eq "1" ]] && verboseOut "Creating screenfetch-export.tar.gz archive in /tmp/screenfetch-export/...."
	tar -czf screenfetch-export.tar.gz ../screenfetch-export &>/dev/null
	mv /tmp/screenfetch-export/screenfetch-export.tar.gz $HOME/
	echo -e "${bold}==>${c0} Archive created in /tmp/ and moved to $HOME. Removing /tmp/screenfetch-export/..."
	rm -rf /tmp/screenfetch-export/
}


##################
# Let's Do This!
##################

for i in "${display[@]}"; do

	if [[ $i =~ wm ]]; then
		 ! [[ $WM  ]] && detectwm; 
		 ! [[ $Win_theme ]] && detectwmtheme;
	else

	  [[ "${display[*]}" =~ "$i" ]] && detect${i}

	fi
done
infoDisplay
[ "$screenshot" == "1" ] && takeShot
[ "$exportTheme" == "1" ] && themeExport
