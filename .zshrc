# James' Zsh Config

# Source env and aliases
source ~/.zprofile
source ~/.config/.aliasrc

# Lines configured by zsh-newuser-install
HISTFILE=~/.cache/zsh_history
HISTSIZE=2000
SAVEHIST=2000
setopt extendedglob
unsetopt autocd beep nomatch

setopt append_history hist_ignore_all_dups hist_ignore_space
setopt share_history

setopt glob_dots

# vi mode setup
bindkey -v
export KEYTIMEOUT=1

# End of lines configured by zsh-newuser-install
#
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _match _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'l:|=* r:|=*' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' match-original both
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' menu select=2
zstyle ':completion:*' old-list never
zstyle ':completion:*' old-menu false
zstyle ':completion:*' select-prompt %SScrolling active: current selection at%p%s
zstyle ':completion:*' substitute 0
zstyle :compinstall filename '/home/james/.zshrc'

autoload -Uz compinit
compinit

# End of lines added by compinstall

# Manual Git Plugin
autoload -Uz vcs_info
precmd_functions+=( vcs_info )
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' check-for-staged-changes true
zstyle ':vcs_info:git:*' enable git
zstyle ':vcs_info:git:*' stagedstr '$'
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' formats '%F{red}%u%F{cyan}%c%F{green}[%b]'
zstyle ':vcs_info:git:*' actionformats '%F{red}%u%F{cyan}%c%F{green}[%b|%a]'

# main prompt and right prompt
RPROMPT='${vcs_info_msg_0_}'
PS1='%F{cyan}[%~]%(?.%F{green}$.%F{red}$)%f '

# Do on startup
lent-reminder.sh
todo.sh

# Source FZF
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
