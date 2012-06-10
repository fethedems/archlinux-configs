#!/usr/bin/python

#	DEMSoft LABS							
#	This script has been created for changing	
#	the gnome-shell wallpaper like in windows	
#	presentations. ENJOY!					

import os
import time
import sys

# METODOS AUXILIARES

def verifyArguments():
	if (len(sys.argv) != 3) or (not os.path.isdir(sys.argv[1])):
		print ("Especifique bien los parámetros de entrada:")
		print()
		print (">>> python WallChanger.py DIR_DE_IMAGENES TIME")
		print()
		input("Presione cualquier tecla para continuar...")
		return False		
	return True

def validImageFormat(format):
	if format == ".jpg" or format == ".png" or format == ".gif":
		return True
	return False

def WallChanger():

	IMAGE_DIR = sys.argv[1]
	TIME = float(sys.argv[2])
	
	images = os.listdir(IMAGE_DIR)
	# sizeFolder = len(images)
	
	# Reducimos la lista dejando solo los archivos válidos
	images = [ image for image in images if ( os.path.isfile(IMAGE_DIR + "/" + image) and validImageFormat(os.path.splitext(image)[1]) ) ]
	
	print (images)

	while True:	
		for image in images:
			command = "gsettings set org.gnome.desktop.background picture-uri file:///" + IMAGE_DIR+"/"+"\""+image+"\""
			os.system(command)
			time.sleep( TIME )		

# LLAMAMOS AL MÉTODO
if verifyArguments():
	WallChanger()
