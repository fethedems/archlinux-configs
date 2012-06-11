#!/bin/bash

# this script allows using webcam properly in skype -- ONLY 64 bit Linux OS
LD_PRELOAD=/usr/lib32/libv4l/v4l1compat.so skype
