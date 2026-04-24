#######################################
#               Pacman                #
#######################################

# Pacman - https://wiki.archlinux.org/title/Pacman/Tips_and_tricks

(( $+commands[pacman] )) || return 0

function pac() {
    case $1 in
    add)
    sudo pacman -S ${@:2}
    ;;
    remove)
    sudo pacman -Rs ${@:2}
    ;;
    upg)
    sudo pacman -Syu
    ;;
    upgrade)
    sudo pacman -Syu
    ;;
    list)
    if command -v fzf > /dev/null; then
    pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'
    else
    pacman -Qq | less
    fi
    ;;
    search)
    if [[ "$#" == 2 ]]; then
    if command -v fzf > /dev/null; then
    pacman -Slq | grep $2 | fzf --preview 'pacman -Si {}' --layout=reverse --bind 'enter:execute(pacman -Si {} | less)'
    else
    pacman -Slq | grep $2 | xargs pacman -Si | less
    fi
    else
    if command -v fzf > /dev/null; then
    pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse --bind 'enter:execute(pacman -Si {} | less)'
    else
    pacman -Slq | xargs pacman -Si | less
    fi
    fi
    ;;
    prune)
    local orphans
    orphans=$(pacman -Qtdq)
    if [[ -n $orphans ]]; then
    sudo pacman -Rns ${=orphans}
    fi
    ;;
    own)
    pacman -Qo ${@:2}
    ;;
    tree)
    if command -v pactree > /dev/null; then
    pactree ${@:2}
    else
    echo 'Install `pacman-contrib` to use pactree(8).'
    fi
    ;;
    why)
    if command -v pactree > /dev/null; then
    pactree -r ${@:2}
    else
    echo 'Install `pacman-contrib` to use pactree(8).'
    fi
    ;;
    clean)
    if command -v paccache > /dev/null; then
    paccache -r
    else
    echo 'Install `pacman-contrib` to use paccache(8).'
    fi
    ;;
    esac
}

fpath=("${0:A:h}" $fpath)
autoload -Uz _pac
