#!/bin/bash

# This scripts allows you to connect your /home directory to a remote repository and
# upload all changes automatically. Don't forget configure your .gitignore file.

# @author: Fernando Moro
# @date: 10 - June - 2012
# @TODO: 

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

OPTERR=0

while getopts "ih" option
do
	case "$option" in
	i) #init
		git init
		git add.	
		# Reading commit
		echo "Please, insert a new commit:"
		read COMMIT
		# Updating...
		git commit -m "$COMMIT"
		exit 0
		;;

	h) # Displays help

		githelp
		exit 0
		;;
	
	*) echo "actualizar_git [-h] [-i]" 
		echo "FLAGS:"
		echo "-i: init"
		echo "-h: display help"
		exit 0
		;;

	esac
done

# If there aren't flags, actualize
addCommit
