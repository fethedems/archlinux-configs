#!/bin/bash

# This scripts allows you to connect your /home directory to a remote repository and
# upload all changes automatically. Don't forget configure your .gitignore file.

# @author: Fernando Moro
# @date: 10 - June - 2012
# @TODO: Verificar si en el directorio actual existe un directorio .git [si hay un repositorio].
#        Soporte para la creación de nuevo repositorio, permitiendo conexión a un servidor nuevo.
#        Incluir la ayuda de DIALOG, que se mostrará con el flag -h

function addCommit ()
{
	# Go to /home 
	cd $HOME
	echo "Moving to: $(pwd)"
	# Add changes
	echo "Adding changes..."
	git add .
	# Reading commit
	echo "Please, insert a new commit:"
	read COMMIT
	# Updating...
	git commit -m "$COMMIT"
	
	# Uploading to GitHub...
	echo "Choose a repository branch: <default: master>"
	echo "Branches:"
	echo "######################"
	git branch
	echo "######################"
	read RAMA
	
	# Select a branch... 
	if [ "$RAMA" != "" ]
	then
		echo "Uploading to GitHub, branch $RAMA..."
		git push -u origin "$RAMA"
	else
		echo "You don't have chosen any branch, uploading repository to MASTER..."
		git push -u origin master
	fi
}

function githelp
{
dialog --colors --backtitle "DEMS ® 2011" --title "GIT-COMMANDOS - BY DEMS" \
--msgbox "\Zb\Z1INICIO \Zn
$ git init
$ git add .
$ git commit -m <nombre>
\Zb\Z1RESPALDOS POSTERIORES \Zn
$ git commit -a -m <nombre2>
\Zb\Z1COMPROBAR CAMBIOS \Zn
$ git status
\Zb\Z1VER RESPALDOS \Zn
$ git log
\Zb\Z1CARGAR RESPALDOS \Zn
$ git checkout master
$ git checkout SHA1_HASH
$ git checkout :/'nombre'
$ git checkout master~5 (5o estado hacia atras)
$ git checkout SHA1_HASH <archivo> <archivo2>
\Zb\Z1ETIQUETAS \Zn
$ git tag <nombre> [<HASH commit>]
\Zb\Z1CREAR RAMA \Zn
$ git checkout -b <rama>
\Zb\Z1BORRAR RAMA \Zn
$ git branch -d <rama>
\Zb\Z1LISTAR RAMAS \Zn
$ git branch
\Zb\Z1POSICIONARSE EN RAMA \Zn
$ git checkout <rama>
$ git checkout master (rama principal)

" 0 0
clear

}

while getopts "iah" option
do
	case "$option" in
	i)	#init

		git init
		git add.	
		# Reading commit
		echo "Please, insert a new commit:"
		read COMMIT
		# Updating...
		git commit -m "$COMMIT"
		;;

	a)	#actualize

		if [ -d "$HOME/.git" ]
		then
			addCommit
		else
			echo "You should initialice your repository."
			exit 0
		fi
		;;

	h) # Displays help

		githelp
		;;
	
	*) echo "Use: actualizar_git [-h] [-i] [-a]"
		echo "-a: actualize"
		echo "-i: init"
		echo "-h: display help"
		;;

	esac
done



if [ -d "$HOME/.git" ]
then
	addCommit
else
	echo "You should initialice your repository."
	exit 0
fi
