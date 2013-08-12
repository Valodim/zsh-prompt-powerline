# a lot of vcs_info related stuff happened here
autoload -U is-at-least
is-at-least 4.3.12 || return

# This file actually adds two hooks. One works with vcs_info, changing the path
# segments into non-ambiguous path prefix versions. The second works with the
# prompt directly, assuming psvar[1] / %1v is used for the path name.

# original disambiguate by Mikachu

# usage of disambiguate:
# disambiguate /usr/share/zsh/function ; echo $REPLY
#  -> /u/sh/zs/f
# disambiguate -k /usr/share/zsh/function ; echo $REPLY
#  -> /u/sh/zs/function
# disambiguate -k zsh/function /usr/share/ ; echo $REPLY
#  -> zs/function


disambiguate () {

    # for compatibility
    setopt localoptions noksharrays

    # this is a modification of Mikachu's disambiguate-keeplast, adding support
    # for an argument to use instead of PWD, and a second argument which is
    # used as a prefix for globbing, but is not part of the disambiguated path.
    # it also supports the -k parameter to keep the last part intact (rather
    # than using a second function for this behavior)

    local short full part cur
    local first
    local -a split    # the array we loop over

    # need to do it this way
    local treatlast=1
    if [[ $1 == '-k' ]]; then
        treatlast=
        shift
    fi

    1=${1:-$PWD}
    local prefix=$2

    if [[ $1 == / ]]; then
      REPLY=/
      return 0
    fi

    # We do the (D) expansion right here and
    # handle it later if it had any effect
    split=(${(s:/:)${(Q)${(D)1:-$1}}})

    # Handling. Perhaps NOT use (D) above and check after shortening?
    if [[ -z $prefix && $split[1] = \~* ]]; then
      # named directory we skip shortening the first element
      # and manually prepend the first element to the return value
      first=$split[1]
      # full should already contain the first
      # component since we don't start there
      full=$~split[1]
      shift split
    fi

    # we don't want to end up with something like ~/
    if [[ -z $prefix ]] && (( $#split > 0 )); then
        part=/
    fi

    # loop over all but the last, plus the last if keeplast is zero
    for cur in $split[1,-2] ${treatlast:+$split[-1]}; {
        while {
            part+=$cur[1]
            cur=$cur[2,-1]
            local -a glob
            glob=( $prefix$full/$part*(-/N) )
            # continue adding if more than one directory matches or
            # the current string is . or ..
            # but stop if there are no more characters to add
            (( $#glob > 1 )) || [[ $part == (.|..) ]] && (( $#cur > 0 ))
        } { # this is a do-while loop
    }
      full+=$part$cur
      short+=$part
      part=/
    }

    # piece them together
    REPLY=$first$short
    # if we skipped the last, add it unaltered
    (( ! treatlast )) && REPLY+=$part$split[-1]

    return 0

}

# sets psvar[1] to unambiguous prefix style path
+prompt-path-disambiguate () {
    disambiguate -k
    psvar[1]=$REPLY

    # don't interfere with other hooks
    return 0
}

# this vcs_info hook changes the base and subdir variables, which are used as
# %R and %S in vcs_info styles, to non-ambiguous prefix versions, keeping the
# last path element intact.
#
# depends on disambiguate-keeplast with prefix support. plays nice with
# vcs_info-lofi.

+vi-path-disambiguate () {
    if [[ $hook_com[subdir] == '.' ]]; then
        disambiguate -k $hook_com[base]
    else
        disambiguate $hook_com[base]
    fi
    hook_com[base]=$REPLY
    disambiguate -k $hook_com[subdir] $hook_com[base]
    hook_com[subdir]=$REPLY

    # we don't set ret here, since this hooks merely influences the displayed
    # info, not any logic
    return 0
}

# don't override other styles with our own - add it to the list!
() {
    local hooks
    zstyle -a ':prompt:*:ps1' precmd-hooks hooks
    zstyle ':prompt:*:ps1' precmd-hooks $hooks +prompt-path-disambiguate
}

# use vcs_info_hookadd to add hooks in a conflict free way
autoload -U vcs_info_hookadd
vcs_info_hookadd set-message path-disambiguate
# this works with lofi-messages as well!
vcs_info_hookadd set-lofi-message path-disambiguate
