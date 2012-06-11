#!/bin/bash

# load module vboxdrv
gksudo modprobe vboxdrv
# open windows VM called "Windows Lite"
VBoxManage startvm "Windows Lite"
