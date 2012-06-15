# Load aliases and personal functions

if [ -f ~/.bash_aliases ];
then
  . ~/.bash_aliases
fi

if [ -f ~/.bash_functions ];
then
  . ~/.bash_functions
fi


# MI PROMPT

set_prompt ()
{
while [[ i -lt $(tput cols) ]]
do
	cadena=$cadena-
	let i=i+1
done
	echo "$cadena"
}

shopt -s checkwinsize
export PS1='$(set_prompt)\n┌─☢ \033[1;31m\u\033[0m ☭ \033[1;35m\h\033[0m ☢──[\033[1;35m\w\033[0m]\$ \033[0m\n└─(\t)──> '
