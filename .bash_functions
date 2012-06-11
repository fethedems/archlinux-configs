##Define colors
#cyan='\e[0;36m'
#light='\e[1;36m'
#NC='\e[0m'
#Logo
#echo -e "  ${light}"
#echo -e "                 +"
#echo -e "                 A"
#echo -e "                RCH                ${cyan}Arch Linux${NC}" `uname -mr`
#echo -e "  ${light}             ARCHA               ${NC}"`date +%c`
#echo -e "  ${light}             RCHARC              "
#echo -e "              ; HARCH;            "
#echo -e "             +AR.CHARC            "
#echo -e "            +HARCHARCHA           "
#echo -e "           RCHARC${cyan}HARCH${light}AR;          "
#echo -e "          CHA${cyan}RCHARCHARCHA${light}+         "
#echo -e "         R${cyan}CHARCH   ARCHARC        "
#echo -e "       .HARCHA;     ;RCH;\`\"."
#echo -e "      .ARCHARC;     ;HARCH."
#echo  "      ARCHARCHA.   .RCHARCHA\`"
#echo  "     RCHARC'           'HARCHA"
#echo  "    ;RCHA                 RCHA;"
#echo  "    RC'                     'HA"
#echo  "   R'                         \`C"
#echo  "  '                            \`"
# 
#echo -e "${NC}"

if [ $(($RANDOM%2)) -eq 0 ]
then
   sh ~/Scripts/inicio.sh
else
   sh ~/Scripts/inicio.sh -D Linux
fi

echo
#--------------------------------------------------------
# Colores
#--------------------------------------------------------
export GRAY="\033[1;30m"
export LIGHT_GRAY="\033[0;37m"
export WHITE="\033[1;37m"
export LIGHT_BLUE="\033[1;34m"
export YELLOW="\033[1;33m"
export BLACK="\033[0;30m"
export RED="\033[0;31m"
export LIGHT_RED="\033[1;31m"
export GREEN="\033[0;32m"
export LIGHT_GREEN="\033[1;32m"
export BROWN="\033[0;33m"
export BLUE="\033[0;34m"
export LIGHT_BLUE="\033[1;34m"
export PURPLE="\033[0;35m"
export LIGHT_PURPLE="\033[1;35m"
export CYAN="\033[0;36m"
export LIGHT_CYAN="\033[1;36m"

export NO_COLOUR="\033[0m"

#export name="\033["
  
#--------------------------------------------------------
# Lista de comandos creados por mi
#--------------------------------------------------------
function miscomandos
{
dialog --colors --backtitle "DEMS ® 2011" --title "COMANDOS PERSONALIZADOS - BY DEMS" \
--msgbox "\Zb\Z1COMANDOS GENERALES \Zn
	informacion = man
	limpiar = clear
	cls = clear
	cd.. = cd ..
\Zb\Z1MANEJO DE PAQUETES \Zn
	alias irep='yaourt -S'
	alias quitar='yaourt -R'
	alias purgar='yaourt -Rs'
	alias buscar='yaourt -Ss'
	alias actualizar='yaourt -Syu'
	alias listar='yaourt -Q'
	alias tengo='yaourt -Qi'
	alias info='yaourt -Si'
\Zb\Z1ACCIONES SOBRE DEMONIOS \Zn
	alias restartd='sudo rc.d restart'
	alias stopd='sudo rc.d stop'
	alias initd='sudo rc.d start'

	alias 'addpath:'='export PATH=PATH:'
\Zb\Z1FUNCIONES EXTRA \Zn
	drae 'palabra' = buscar palabra en diccionario
	miserver = acceder a servidor SSH
	verip (-l/-p/ayuda) = mostrar mis IP's (publica-local)
	githelp = comandos utiles en GIT
" 0 0
clear

}
#--------------------------------------------------------
# Buscar una palabra en el DRAE
#--------------------------------------------------------
function drae
{
if [ ! -f /usr/bin/links ]
then echo -e "Debes instalar links para ejecutar esta aplicación"
exit 1
fi
  if test -z $1
  then
    echo "Uso: `basename $0` palabra"
  else
    #echo "Permalink: http://buscon.rae.es/draeI/SrvltGUIBusUsual?LEMA=$1&TIPO_HTML=2"
    echo "Generando definicion, esto puede tardar..."
    echo
    links -no-g -dump "http://buscon.rae.es/draeI/SrvltGUIBusUsual?LEMA=$1&TIPO_HTML=2"
    echo
  fi 
}
#--------------------------------------------------------
# Conectar a mi servidor SSH
#--------------------------------------------------------
function miserver
{
#variables:
username=$(whoami)
iplocal="xxx.xxx.x.xxx"
ippublic="xx.xxx.xxx.xx"
puerto="8083"

#donde me conecto:
echo -e "$YELLOW$(whoami)$NO_COLOUR@$LIGHT_BLUE$ippublic$NO_COLOUR:$WHITE$puerto$NO_COLOUR"

#comando
ssh -p $puerto $(whoami)@$ippublic
}
#--------------------------------------------------------
# Hallar la IP local y pública de mi equipo
#--------------------------------------------------------
function verip
{
#Hallamos las IP
ip_local=$(sudo ifconfig | grep "inet " | grep -v 127 | cut -d " " -f10)
ip_publica=$(wget -qO- ifconfig.me/ip)

#Las mostramos
case $1 in
"ayuda")
   echo -e "Usar -l o -p para mostrar local o pública"
   ;;
"-l")
   echo -e "IPs para $(hostname)"
   echo -e "  IP Local: $YELLOW$ip_local$NO_COLOUR"
   echo
   ;;
"-p")
   echo -e "IPs para $(hostname)"
   echo -e "  IP Pública: $LIGHT_BLUE$ip_publica$NO_COLOUR"
   echo
   ;;
*)
   echo
   echo -e "IPs para $(hostname)"
   echo -e "  IP Local: $YELLOW$ip_local$NO_COLOUR"
   echo -e "  IP Pública: $LIGHT_BLUE$ip_publica$NO_COLOUR"
   echo
   ;;
esac
}

# APOYO DE GIT

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

# COMBO CD-LS
cd ()
{
	if [ -n "$1" ]; then
		builtin cd "$@" && ls
	else
		builtin cd ~ && ls
	fi
}

# MI PROMPT
export PS1='┌─☢ \033[1;31m\u\033[0m ☭ \033[1;35m\h\033[0m ☢──[\033[1;35m\w\033[0m]\$ \033[0m\n└─(\t)──> '

# EXPORTAMOS EL PATH DE RAILS
export PATH=$PATH:/home/ferthedems/.gem/ruby/1.9.1/bin
