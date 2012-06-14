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
--msgbox "\Zb\Z1INIT A REPOSITORY \Zn
$ git init
$ git add .
$ git commit -m <text>
\Zb\Z1BACKUP A COMMIT\Zn
$ git commit -a -m <text>
\Zb\Z1VIEW CHANGES \Zn
$ git status
\Zb\Z1VIEW COMMITS\Zn
$ git log
\Zb\Z1LOAD COMMIT \Zn
$ git checkout master
$ git checkout SHA1_HASH
$ git checkout :/'name'
$ git checkout master~5 (5th commit before)
$ git checkout SHA1_HASH <file> <file2> <...>
\Zb\Z1TAGS \Zn
$ git tag <name> [<HASH commit>]
\Zb\Z1CREATE NEW BRANCH\Zn
$ git checkout -b <branch>
\Zb\Z1DELETE BRANCH \Zn
$ git branch -d <branch>
\Zb\Z1LIST BRANCHES \Zn
$ git branch
\Zb\Z1CHANGE FOREGROUND BRANCH \Zn
$ git checkout <branch>
$ git checkout master (main branch)

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
