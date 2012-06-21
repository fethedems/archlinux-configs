#!/bin/bash

echo "Script para seleccionar qué radio queremos escuchar"
echo ""
echo " 1 -> Los 40 principales"
echo " 2 -> Cadena dial"
echo " 3 -> Europa FM"
echo " 4 -> Cadena Ser"
echo " 5 -> Onda Cero"
echo " 6 -> Kiss FM"
echo " 7 -> RNE 1"
echo " 8 -> COPE"
echo " 9 -> RNE clásica"
echo " 10 -> m80 Radio"
echo " X -> Salir"
echo ""
echo "Seleccione una de las radios:"

read radio

if [ "$radio" = "1" ]; then
	mplayer -playlist http://www.los40.com/nuevo_player/40Principales.asx
elif [ "$radio" = "2" ]; then
	mplayer -playlist http://www.los40.com/nuevo_player/dial.asx
elif [ "$radio" = "3" ]; then
	mplayer -playlist http://www.ondacero.es/europafm.asx
elif [ "$radio" = "4" ]; then
	mplayer -playlist  http://www.cadenaser.com/player/SER-TIC.asx
elif [ "$radio" = "5" ]; then
	mplayer -playlist  mms://www.ondacero.es/live.asx
elif [ "$radio" = "6" ]; then
	mplayer -playlist http://pointers.audiovideoweb.com/asxfiles-live/ny60winlive7001.asx
elif [ "$radio" = "7" ]; then
	mplayer -playlist http://www.rtve.es/rne/audio/r1live.asx
elif [ "$radio" = "8" ]; then
	mplayer -playlist mms://live.cope.edgestreams.net/reflector:34744
elif [ "$radio" = "9" ]; then
	mplayer -playlist http://www.rtve.es/rne/audio/RNEclasica.asx
elif [ "$radio" = "10" ]; then
	mplayer -playlist  http://www.los40.com/nuevo_player/m80.asx
elif [ "$radio" = "X" ]; then
	exit
else; then
	echo "Opción no válida :-("
fi

