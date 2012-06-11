# My personal command aliases

# System commands
alias informacion='man'
alias limpiar='clear'
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
alias irep='yaourt -S'
alias quitar='yaourt -R'
alias purgar='yaourt -Rs'
alias buscar='yaourt -Ss'
alias actualizar='yaourt -Syu --aur --devel --noconfirm'
alias listar='yaourt -Q'
alias tengo='yaourt -Qi'
alias info='yaourt -Si'