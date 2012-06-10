#!/bin/bash

#cargamos los módulos
gksudo modprobe vboxdrv
#le damos caña
VBoxManage startvm "Windows Lite"
