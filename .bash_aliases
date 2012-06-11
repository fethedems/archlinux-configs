# My personal command aliases

# System commands
alias cls='clear'
alias cd..='cd ..'
alias ls='ls --color=auto'

# Daemons
alias restartd='sudo rc.d restart'
alias stopd='sudo rc.d stop'
alias initd='sudo rc.d start'

#PATH
alias 'addpath:'='export PATH=$PATH:'

# Package managing
alias paci='yaourt -S' # nemotecnic rule: "pacman install"
alias pacu='yaourt -R' # nemotecnic rule: "pacman uninstall"
alias pacp='yaourt -Rs' # nemotecnic rule: "pacman purge"
alias search='yaourt -Ss' # nemotecnic rule: "pacman search"
alias paca='yaourt -Syu --aur --devel --noconfirm' # nemotecnic rule: "pacman actualize"
alias listar='yaourt -Q'
alias tengo='yaourt -Qi'
alias pinfo='yaourt -Si' # nemotecnic rule: "pacman info"
