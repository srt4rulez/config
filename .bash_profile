# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# Aliases
alias ll='ls -alFh'
alias resource='source ~/.bash_profile && echo "Done!"'

# reset filemode
alias gitfilemode='git config --unset core.filemode'

# Shortcuts
alias www='cd /opt/www'
alias cdcs='cd /opt/www/conduit-server/conf-modules'
alias llcs='ll /opt/www/conduit-server/conf-modules'
alias pub='cd ~/public_html'

# Exercism Completion
# Install:
# cd ~
# wget http://cli.exercism.io/exercism_completion.bash
if [ -f ~/exercism_completion.bash ]; then
    source ~/exercism_completion.bash
fi

# WP CLI Completion
# Install:
# cd ~
# wget https://raw.githubusercontent.com/wp-cli/wp-cli/master/utils/wp-completion.bash
if [ -f ~/wp-completion.bash ]; then
    source ~/wp-completion.bash
fi

# Git Completion
# Install:
# cd ~
# wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
if [ -f ~/git-completion.bash ]; then
    source ~/git-completion.bash
fi

# Git Prompt
# Install:
# cd ~
# wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
if [ -f ~/git-prompt.sh ]; then
    source ~/git-prompt.sh
fi

export GIT_PS1_SHOWDIRTYSTATE=1                # '*'=unstaged, '+'=staged
export GIT_PS1_SHOWSTASHSTATE=1                # '$'=stashed
export GIT_PS1_SHOWUNTRACKEDFILES=1            # '%'=untracked
export GIT_PS1_SHOWUPSTREAM="verbose"          # 'u='=no difference, 'u+1'=ahead by 1 commit

export GIT_PS1_DESCRIBE_STYLE="branch"
# detached HEAD style:
#  contains      relative to newer annotated tag (v1.6.3.2~35)
#  branch        relative to newer tag or branch (master~4)
#  describe      relative to older annotated tag (v1.6.3.1-13-gdd42c2f)

# https://stackoverflow.com/a/38758377/3837451

# Check if we support colours
__colour_enabled() {
    local -i colors=$(tput colors 2>/dev/null)
    [[ $? -eq 0 ]] && [[ $colors -gt 2 ]]
}
unset __colourise_prompt && __colour_enabled && __colourise_prompt=1

__set_bash_prompt() {

    # PS1 is made from $preGitPS1 + <git-status> + $postGitPS1
    local preGitPS1="\n"
    local postGitPS1=""

    if [[ $__colourise_prompt ]]; then

        export GIT_PS1_SHOWCOLORHINTS=1

        # Wrap the colour codes between \[ and \], so that
        # bash counts the correct number of characters for line wrapping:
        local red='\[\e[0;31m\]'; local bRed='\[\e[1;31m\]'
        local gre='\[\e[0;32m\]'; local bGre='\[\e[1;32m\]'
        local yel='\[\e[0;33m\]'; local bYel='\[\e[1;33m\]'
        local blu='\[\e[0;34m\]'; local bBlu='\[\e[1;34m\]'
        local mag='\[\e[0;35m\]'; local bMag='\[\e[1;35m\]'
        local cya='\[\e[0;36m\]'; local bCya='\[\e[1;36m\]'
        local whi='\[\e[0;37m\]'; local bWhi='\[\e[1;37m\]'
        local none='\[\e[0m\]' # Return to default colour

        # Red if root
        if [[ ${EUID} == 0 ]]; then
            preGitPS1+="$bRed\u$yel@$mag\h$none: "
        else
            preGitPS1+="$mag\u$yel@$mag\h$none: "
        fi

        preGitPS1+="$blu\w $none"

    else # No colour

        # Sets prompt like: ravi@boxy:~/prj/sample_app
        unset GIT_PS1_SHOWCOLORHINTS
        preGitPS1="${debian_chroot:+($debian_chroot)}\u@\h:\w"

    fi

    # Now build the part after git's status

    # Change colour of prompt if root
    if [[ ${EUID} == 0 ]]; then
        postGitPS1+=" \n$bRed"'\$ '"$none"
    else
        postGitPS1+=" \n$mag"'\$ '"$none"
    fi

    # Set PS1 from $preGitPS1 + <git-status> + $postGitPS1
    __git_ps1 "$preGitPS1" "$postGitPS1" '(%s)'

}

# This tells bash to reinterpret PS1 after every command, which we
# need because __git_ps1 will return different text and colors
PROMPT_COMMAND=__set_bash_prompt

PATH=$PATH:$HOME/bin:$HOME/.composer/vendor/bin:$HOME/.yarn/bin

export PATH

# Colors for ls
LS_COLORS=$LS_COLORS:'di=0;35:' ; export LS_COLORS

export VAGRANT_DEFAULT_PROVIDER=hyperv
