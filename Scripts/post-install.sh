#!/bin/bash

echo "#############################"
echo "Script post-install ARCHLINUX"
echo "#############################"

dialog --clear --checklist "Choose all you want to install:" 0 0 0\
			 1 "Xorg basics" on \
			 2 "GNOME-Shell + extras" off \
			 3 "KDE"  off\
			 4 "XFCE" off\
			 5 "OPENBOX" off\
			 6 "Nouveau video driver for NVIDIA" off\
			 7 "NVIDIA official video driver" off\
 			 8 "ATI video driver" off\
 			 9 "INTEL video driver" off\
			 10 "Create basic directories: Pictures, Documents..." off\
			 11 "Codecs GSTREAMER" off\
			 12 "Flash Plugin" off\
			 12 "gVIM" off\
			 13 "Chromium" off\
			 14 "Opera" off\
			 15 "Firefox" off\
			 16 "jDownloader" off\
			 17 "qBitTorrent" off\
			 18 "Wine" off\
			 19 "Libre Office" off\
			 20 "Skype" off\
			 21 "Eclipse" off\
			 22 "Netbeans" off\
			 23 "" off\




#sudo pacman -S xorg-server xorg-xinit xorg-utils xorg-server-utils


## Directorios iniciales

#echo
#echo "Creando directorios iniciales..."
	#mkdir $HOME"/Pictures"
	#mkdir $HOME"/Documents"
	#mkdir $HOME"/Downloads"
	#mkdir $HOME"/Videos"
#echo

## Instalaciones básicas

#echo "Instalando los códecs..."
	#sudo pacman -S gstreamer0.10-{{bad,good,ugly,base}{,-plugins},ffmpeg}
#echo "Instalando GVim"
	#sudo pacman -S gvim
#echo "Instalando plugins de VIM"
	#sudo yaourt -S eclim vim-bufexplorer vim-nerdcommenter vim-nerdtree vim-omnicppcomplete vim-project vim-pydiction vim-taglist vim-workspace --noconfirm
#echo "Instalando navegadores, gestor de correo..."
	#sudo pacman -S opera firefox chromium thunderbird firefox-i18n-es-es thunderbird-i18n-es
#echo "Instalando gestores de descargas..."
	#yaourt -S jdownloader --noconfirm
	#yaourt -S qbittorrent --noconfirm
	#pacman -S deluge
#echo "Instalando wine..."
	#sudo pacman -S wine
#echo "Instalando dropbox..."
	#yaourt -S dropbox --noconfirm	
#echo "Instalando libre office"
	#pacman -S libreoffice libreoffice-es
#echo "Intalando skype"
	#pacman -S skype
#echo "Instalando aplicaciones de programación"
	#pacman -S eclipse
	#pacman -S netbeans

## Configuraciones básicas

#echo
#echo "##################################"
#echo "Moviendo archivos de configuración"
#echo "##################################"
#echo 
#echo "Archivos de configuración de BASH"
	#mv "\""$(pwd)"\"/.bashrc" $HOME
	#mv "\""$(pwd)"\"/.bash_functions" $HOME
	#mv "\""$(pwd)"\"/.bash_aliases" $HOME
#echo
#echo "Archivos de configuración de CONKY"
	#mv $(pwd)"/.conkyrc" $HOME
#echo
#echo "Archivo de configuración de VIM" 
	#sudo mv $(pwd)"/vimrc" /etc/
#echo
#echo "############################"
#echo "Abandonando la aplicación..."
#echo "############################"

