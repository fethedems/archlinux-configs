#!/bin/bash

# Script para actualizar el repositorio central del sistema,
# alojado en github


# @author: Fernando Moro
# @date: 10 - June - 2012

# Nos colocamos en el home
cd $HOME
echo "Moviendo al directorio $(pwd)"
# Añadimos los cambios
echo "Añadiendo cambios"
git add .
# Leemos el commit
echo "Introduce el commit a añadir:"
read COMMIT
# Actualizamos...
git commit -m "$COMMIT"
# Lo subimos a GitHub
echo "Subiendo el repositorio a GitHub..."
git push -u origin master
