#!/usr/bin/python
import os
import subprocess
import re

if os.path.isfile("/usr/bin/dialog"):
	print("Se cumple con las dependencias requeridas")
else:
	print("No se cumple con las dependencias requeridas. ERROR.")

# Array with the initial programs. The main structure is:
# [ [ name ] [command] ]

apps = [
# DE
['XOrg Basics','sudo pacman -S xorg-server xorg-xinit xorg-utils xorg-server-utils'],
['Gnome Shell','pacman -Syu gnome gnome-extra'],
['KDE','sudo pacman -S kde # kde-l10n-es IDIOMA ESPAÑOL'],
['Lenguaje español - KDE','sudo pacman kde-l10n-es'],
['XFCE','sudo pacman -S xfce4'],
['OpenBox','sudo pacman -S openbox'],
# VIDEO DRIVERS
['Nouveau video driver','sudo pacman -S xf86-video-nouveau'],
['NVIDIA video driver','sudo pacman -S nvidia nvidia-utils # run sudo nvidia-xconfig after rebooting'],
['ATI video driver','sudo pacman -S xf86-video-ati'],
['INTEL video driver','sudo pacman -S xf86-video-intel'],
# PLUGIN - CODECS
['Flash Plugin','sudo pacman -S flashplugin'],
['Codecs GSTREAMER','sudo pacman -S gstreamer0.10-{{bad,good,ugly,base}{,-plugins},ffmpeg}'],
# DEVELOPERS TOOLS
['gVIM','sudo pacman -S gvim'],
['Eclipse','pacman -S eclipse'],
['Netbeans','pacman -S netbeans'],
# SOCIAL
['Skype','pacman -S skype'],
['Pidgin','pacman -S pidgin'],
['Emesene','pacman -S emesene'],
# INTERNET
['Firefox','pacman -S firefox'],
['Chromium','pacman -S chromium'],
['Opera','pacman -S opera'],
['Dropbox','yaourt -S dropbox --noconfirm'],
# DOWNLOADS
['jDownloader','yaourt -S jdownloader --noconfirm'],
['qBitTorrent','yaourt -S qbittorrent --noconfirm'],
# OTHER
['Yaourt','sudo pacman -S yaourt #needed archlinuxfr repo'],
['Wine','sudo pacman -S wine'],
['Comix','sudo pacman -S mcomix'],
['Create Basic Directories','sudo pacman -S xdg-user-dirs && xdg-user-dirs-update'],
# FONTS
['Install basic fonts', 'sudo pacman -S ttf-bitstream-vera ttf-dejavu ttf-droid ttf-freefont'],
['Install Microsoft fonts from AUR', 'yaourt -S ttf-ms-fonts']
]

# Initial command
command=['dialog', '--clear', '--checklist', '\'Choose all you want to install:\'', '0', '0', '0']

# BUILD OUR COMMAND
i=0
for app in apps:
	i+=1
	command.append(app[0])
	command.append(str(i))
	command.append('off')

# SHOW DIALOG WINDOW
proc = subprocess.Popen(command, stderr=subprocess.PIPE)
stdout,stderr = proc.communicate()

# GET UOTPUT
output=stderr.decode('utf-8')
output = re.findall('\"([a-zA-Z0-9_ ]+)\"', output)

# INSTALL APPS
os.system("clear")
print("Selected actions:")

for element in output:
	for app in apps:
		if app[0] == element:
			print(app[0],"->",app[1])
			os.system(app[1])
