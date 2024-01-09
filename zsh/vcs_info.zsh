#!/usr/bin/zsh

autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
# zstyle ':vcs_info:*' formats '(%s)-[%b] %F{#CF9FFF}(%c%u) %m%f'
zstyle ':vcs_info:*' formats '%F{#CF9FFF}(%b) [%c%u] %m%f'
zstyle ':vcs_info:*' zstyle ':vcs_info:*' actionformats '(%s)-[%b] %F{yellow}(%c%u) %m%f'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "+"
zstyle ':vcs_info:*' unstagedstr "!"

# Add hooks for git
zstyle ':vcs_info:git*+set-message:*' hooks git-unstaged \
                                            git-untracked \
                                            git-staged

# Unstaged files count
function +vi-git-unstaged() {
    if command git status --porcelain 2> /dev/null \
	    | awk '{print $1}' \
	    | command grep '^.[MTDRC]' > /dev/null 2>&1; then
	unstaged_count=$(git status --porcelain | grep '^.[MTDRC]' | wc -l)
	hook_com[unstaged]+=${unstaged_count}
    fi
}

# Untracked files count
function +vi-git-untracked() {
    if command git status --porcelain 2> /dev/null \
	    | awk '{print $1}' \
	    | command grep '^??' > /dev/null 2>&1; then
        untracked_count=$(git status --porcelain | grep "^??" | wc -l)
	if test -z "$hook_com[unstaged]"; then
            hook_com[unstaged]+='?'${untracked_count}    # append to unstagedstr
	else
	    hook_com[unstaged]+=' ?'${untracked_count}    # append to unstagedstr
	fi
    fi
}

# Staged files count
function +vi-git-staged() {
    if command git status --porcelain 2> /dev/null \
	    | awk '{print $1}' \
	    | command grep '^A' > /dev/null 2>&1; then
	staged_count=$(git status --porcelain | grep '^A' | wc -l)
	hook_com[staged]+=${staged_count}' '
    fi
}

function _update_vcs_info() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"
}

add-zsh-hook precmd _update_vcs_info
