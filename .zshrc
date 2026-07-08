# Philippe's .zshrc
# The Unix shell: the crapiest programming language you'll ever see.

################################################################################
# Path
################################################################################

case `uname` in
    Darwin)
        # Scripts:
        path=("/Users/pgrenet/bin" $path)
        path=("/usr/local/bin" $path)
        # Colored ls:
        path=("/usr/local/opt/coreutils/libexec/gnubin" $path)
        export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
        # Homebrew
        #path=("/usr/local/bin" $path)
     	eval "$(/opt/homebrew/bin/brew shellenv)"
        path=("$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin" $path)
        ;;
    Linux)
        path=("/opt/bb/bin/" $path)
        path=("~/bin/" $path)
        ;;
esac


################################################################################
# Emacs
################################################################################

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

export EMACS='/opt/homebrew/Cellar/emacs-mac@29/HEAD-47022e4/Emacs.app/Contents/MacOS/Emacs'
case `uname` in
    Darwin)
        export EDITOR="$EMACS -nw -Q"
        export GIT_EDITOR="$EMACS -nw -Q"
        alias ez=$EMACS
        ;;
    Linux)
        export EDITOR='/opt/bb/bin/emacs -nw -Q'
        export GIT_EDITOR='/opt/bb/bin/emacs -nw -Q'
      ;;
esac


# C-x C-e to edit the command line in Emacs
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

################################################################################
# Settings
################################################################################

# Keep 10K lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
# APPEND_HISTORY -> zsh sessions will append their history list to the history
# file, rather than replace it. Thus, multiple parallel zsh sessions will all
# have the new entries from their history lists added to the history file, in
# the order that they exit. The file will still be periodically re-written to
# trim it when the number of lines grows 20% beyond the value specified by
# $SAVEHIST (see also the HIST SAVE BY COPY option).
setopt APPEND_HISTORY
#setopt histignorealldups sharehistory

# ZLE emacs-like key bindings (meta arrow)
bindkey "^[[5D" backward-word
bindkey "^[[5C" forward-word

################################################################################
# Completion
################################################################################

# Use modern completion system
autoload -Uz compinit && compinit -u

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
#eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Add auto suggestions on top of that
# See https://github.com/zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(completion history)
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


################################################################################
# Colors
################################################################################

# ls
alias ls="ls --color=auto"
alias la="ls -a"
alias ll="ls -l"

# Terminal colors
export TERM=xterm-256color

# stderr in color ("\e[91m${X}\e[0m" for no bold)
#exec 2>>( while read X; do print "\e[91;1m${X}\e[0m" > /dev/tty; done & )

# Grep in color
export GREP_OPTIONS='--color=always'
export GREP_COLOR='1;31'

# GCC colors
export GCC_COLORS='error=01;31:warning=01;33:note=01;36:caret=01;32:locus=01:quote=01'

################################################################################
# Functions
################################################################################

fpath=(~/.zsh/fn $fpath)

for file in ${HOME}/.zsh/fn/*; do
    if [ -f ${file} ]; then
        #echo "Loading ${file}"
        source ${file}
    fi
done

################################################################################
# Aliases
################################################################################

alias epurge="/bin/rm -f ?*~ .?*~"
alias cls='echo -e "\ec\e[3J"'

case `uname` in
    Darwin)
        #alias e='/opt/homebrew/Cellar/emacs-mac/emacs-28.2-mac-9.1/Emacs.app/Contents/MacOS/Emacs'
        alias ftpdev='sftp -i ~/.toolkit/toolkit_ssh_key_pgrenet devsftp'

        # ssh agent for the Centos VM:
        #alias agent-start='eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_centos'

        # Build-in Apache
        #alias apache-start='sudo launchctl load -w /System/Library/LaunchDaemons/org.apache.httpd.plist'
        #alias apache-stop='sudo apachectl stop'
        # Brew's Apache
        # /usr/local/etc/httpd/httpd.conf
        # tail -f /usr/local/var/log/httpd/error_log
        alias apache-start='sudo apachectl start'
        alias apache-stop='sudo apachectl stop'
        alias apache-restart='sudo apachectl -k restart'

        ## Unsecure Chrome to avoid the CORS error
        alias unsecure-chrome='open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir="/tmp/chrome_dev_test" --disable-web-security'

        # Spark Shell with colors
        alias spark-shell-color='spark-shell --conf spark.driver.extraJavaOptions="-Dscala.color"'

        # PRQS PW
        alias getprodwin='ssh pgrenet@v5prqsgatewayny.bdns.bloomberg.com inline getprdwin'

        # Typo correction
        #eval $(thefuck --alias)
        ;;
    Linux)
        # TODO
      ;;
esac

# Files location in Google drive
export GDRIVE="/Users/pgrenet/Library/CloudStorage/GoogleDrive-pgrenet@bloomberg.net/My Drive/"

################################################################################
# Proxies
################################################################################

export no_proxy="localhost,.bcs.bloomberg.com,.bdns.bloomberg.com,.inf.bloomberg.com,.dev.bloomberg.com,.dev.blpprofessional.com,.bcpc.bloomberg.com,bpv.bloomberg.com,127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.127.0.0/16,100.100.127.0/24,100.100.254.0/24,100.70.0.0/18,100.71.0.0/18"
bbproxy on

################################################################################
# Developer tools
################################################################################

case `uname` in
    Darwin)
        # BDE
        #path=($path "/Users/pgrenet/bql/bde-tools/bin")
        path=($path "/opt/homebrew/opt/bde-format@11/bin")

        ## Java
        path=($path "/opt/homebrew/opt/openjdk@17/bin")
        ## Maven
        export M2_HOME='/Users/pgrenet/bin/apache-maven-3.8.6'
        export M2=$M2_HOME/bin
        path=($path "/Users/pgrenet/bin/apache-maven-3.8.6/bin")

        # Teleport
        export LCLDEV_ENABLE_TELEPORT=1

        # BBVPN reboot
        alias bootime='system_profiler SPSoftwareDataType | grep Time'

        # List USB devices
        alias lsusb="ioreg -p IOUSB -w0 | sed 's/[^o]*o //; s/@.*$//' | grep -v '^Root.*'"

        # fzf
        source <(fzf --zsh)

        # TAB accepts autosuggestion when one is visible, otherwise does completion
        # (must be after fzf --zsh which also binds TAB)
        _autosuggest_or_complete() {
            if [[ -n "$POSTDISPLAY" ]]; then
                BUFFER="$BUFFER$POSTDISPLAY"
                CURSOR=${#BUFFER}
                POSTDISPLAY=""
            else
                if zle -la fzf-completion; then
                    zle fzf-completion
                else
                    zle expand-or-complete
                fi
            fi
        }
        zle -N _autosuggest_or_complete
        ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(_autosuggest_or_complete)
        bindkey '\t' _autosuggest_or_complete

        FZF_DEFAULT_OPTS="--height 50% --layout=default --border"
        export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"
        alias fzfp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"

        # zoxide
        eval "$(zoxide init zsh)"

        # Mermaid / Puppeteer
        # To test do:
        #   echo 'flowchart LR;A-->B' > /tmp/m.mmd
        #   mmdc -i /tmp/m.mmd -o /tmp/m.svg
        #   open /tmp/m.svg
        export PUPPETEER_EXECUTABLE_PATH='/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'

        ## Docker
        ##path=("/Applications/Docker.app/Contents/Resources/bin/" $path)
        ## To enable docker compose v2:
        ## https://docs.docker.com/compose/migrate/#what-are-the-differences-between-compose-v1-and-compose-v2
        ## https://tutti.prod.bloomberg.com/local-development/mac-universal-bootstrapper/README#how-to-enable-the-preview-of-docker-compose-v2
        ## export LCLDEV_ENABLE_COMPOSE_V2=1
      ;;
    Linux)
      # ...
      ;;
esac

################################################################################
# Prompt
################################################################################

# Current directory
path=("." $path)

if [ -f ~/.zsh/prompt ]; then
    source ~/.zsh/prompt
else
    print "Error: ~/.zsh/prompt not found."
fi

#test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

source ~/.lcldevrc

. "$HOME/.local/bin/env"
