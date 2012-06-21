#!/bin/bash

echo "Accediendo a la papelera..."
cd $HOME/.local/share/Trash/files/
echo "$(pwd)"
echo "Presiona una tecla para continuar, CTRL+C para salir..."
read
echo "Eliminando archivos..."
rm -rf *
