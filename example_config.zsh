
# this is an example configuration file for zsh powerline prompt. it shows
# various configuration features and some hooks which you may or may not find
# helpful, and which are supported by the powerline prompt.

# add the directory this file resides in to fpath
fpath+=( $0(:h:a) )

# initialize the prompt contrib
autoload promptinit && promptinit || return 1

zmodload zsh/parameter

# has it been loaded correctly? if not, bail out early.
(( $+functions[prompt_powerline_setup] )) || return 2

# we can never know for sure powerline font is installed, but in my case if I'm
# on rxvt-unicode, chances are good. note that most zstyles have to be set
# before the prompt is loaded since they are not continuously re-evaluated.
[[ $TERM == "rxvt-unicode-256color" ]] || return 3


### additional zstyles

# set some fixed host colors
zstyle ':prompt:*:twilight*'    host-color 093
zstyle ':prompt:*:pinkie*'      host-color 201
zstyle ':prompt:*:rarity'       host-color white
zstyle ':prompt:*:applejack'    host-color 208
zstyle ':prompt:*:fluttershy'   host-color 226

# only show username on remote server or if it's different from my default
[[ -n $SSH_CONNECTION || $USER == valodim ]] && zstyle ':prompt:powerline:ps1' hide-user 1

# enable check-for-changes, for the ¹² indicators in git
zstyle ':vcs_info:*:powerline:*' check-for-changes true

# if you are using the new powerline symbols, uncomment these lines.
 zstyle ':prompt:powerline:ps1:' sep1-char ''
 zstyle ':prompt:powerline:ps1:' sep2-char ''
 zstyle ':prompt:powerline:ps1:' lock-char ''
 zstyle ':prompt:powerline:ps1:' branch-char ''


# added, otherwise hooks wouldn't be found
SCRIPT_SOURCE=${0%/*}

### load some optional hooks which add further functionality. uncomment to enable.

# disambiguate the pathname instead of last three elements (/u/s/z/functions -> share/zsh/functions)
 source $SCRIPT_SOURCE/hooks/prompt-disambiguate.zsh

# show signal names instead of exit codes based on a heuristic (130 -> INT)
 source $SCRIPT_SOURCE/hooks/prompt-exitnames.zsh

# show commits ahead/behind of tracking branch, and number of stashed commits
 source $SCRIPT_SOURCE/hooks/vcs_info-githooks.zsh

# show lo-fi version of vcs info, saving load times in exchange for information
 source $SCRIPT_SOURCE/hooks/vcs_info-lofi.zsh


### done with configuration - actually select the prompt

prompt powerline

