
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
#zstyle ':prompt:*:twilight*'    host-color 093
#zstyle ':prompt:*:pinkie*'      host-color 201
#zstyle ':prompt:*:rarity'       host-color white
#zstyle ':prompt:*:applejack'    host-color 208
#zstyle ':prompt:*:fluttershy'   host-color 226

# only show username on remote server or if it's different from my default
[[ -n $SSH_CONNECTION || $USER == valodim ]] && zstyle ':prompt:powerline:ps1' hide-user 1

# enable check-for-changes, for the ¹² indicators in git
zstyle ':vcs_info:*:powerline:*' check-for-changes true

# If you want to use a different set of separators, specify them here
# The examples given here exist within various parts of the Unicode space.
# Block gradient (color change character)
# zstyle ':prompt:powerline:ps1' sep1-char '▒'
# Central diamond (Secondary separator)
# zstyle ':prompt:powerline:ps1' sep2-char '◆'
# Double Exclaim (Unmodifiable/protected)
# zstyle ':prompt:powerline:ps1' lock-char '‼'
# Option key symnbol (for branch)
# zstyle ':prompt:powerline:ps1' branch-char '⌥'

### load some optional hooks which add further functionality. uncomment to enable.

# disambiguate the pathname instead of last three elements (/u/s/z/functions -> share/zsh/functions)
# source hooks/prompt-disambiguate.zsh

# show signal names instead of exit codes based on a heuristic (130 -> INT)
# source hooks/prompt-exitnames.zsh

# show commits ahead/behind of tracking branch, and number of stashed commits
# source hooks/vcs_info-githooks.zsh

# show lo-fi version of vcs info, saving load times in exchange for information
# source hooks/vcs_info-lofi.zsh


### done with configuration - actually select the prompt

prompt powerline

