#!/bin/bash

echo "Moving to trash directory..."
RUTA_PAPELERA="$HOME/.local/share/Trash/files"

if [ -d $RUTA_PAPELERA ]
then
	cd $RUTA_PAPELERA
	echo "Moviendo al directorio: $(pwd)"
	rm -rf *
	echo "Se han eliminado todos los archivos."
else
	echo "No se encuentra el directorio de la papelera..."
fi
