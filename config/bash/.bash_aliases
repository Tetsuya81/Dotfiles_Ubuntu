# Bash aliases

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# List files
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# System commands
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias purge='sudo apt purge'

# File operations
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Directory operations
alias mkdir='mkdir -p'

# Common tools
alias c='clear'
alias h='history'
alias j='jobs -l'
alias v='vim'
alias hx='helix'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias glo='git log --oneline --graph'

# Python aliases
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv venv'
alias activate='source venv/bin/activate'

# Misc
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias today='date +"%Y-%m-%d"'

# External tools
# broot
alias br='broot'

# btop
alias top='btop'

# Show all running services
alias services='systemctl list-units --type=service --state=running'

# Network aliases
alias ports='netstat -tulanp'
alias myip='curl http://ipecho.net/plain; echo'
