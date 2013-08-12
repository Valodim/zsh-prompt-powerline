
# These are two hooks, adding information about the tracking branch, and the
# number of stashed commits to the prompt.

# Show remote ref name and number of commits ahead-of or behind
+vi-git-tracking () {
    setopt localoptions noksharrays

    local ahead behind remote tmp
    local -a formats

    # Get tracking-formats, or bail out immediately
    zstyle -a ":vcs_info:${vcs}:${usercontext}:${rrn}" trackingformats formats || return 0

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

    if [[ -n ${remote} ]] ; then
        ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
        behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
        if (( ahead && behind )); then
            zformat -f tmp $formats[3] a:$ahead b:$behind
        elif (( ahead )); then
            zformat -f tmp $formats[1] a:$ahead
        elif (( behind )); then
            zformat -f tmp $formats[2] b:$behind
        fi

        hook_com[branch]+=$tmp
    fi
}

# Show count of stashed changes
+vi-git-stash () {
    local -a stashes
    local -a format

    zstyle -s ":vcs_info:${vcs}:${usercontext}:${rrn}" stashformat format || return 0

    if [[ -n $format && -s ${hook_com[base_orig]}/.git/refs/stash ]] ; then
        # find number of stashed commits
        stashes=$(git stash list 2>/dev/null | wc -l)
        (( stashes )) || return 0

        # add to misc
        zformat -f tmp $format s:$stashes
        hook_com[misc]+=$tmp
    fi
}

zstyle ':vcs_info:git+set-message:*' hooks git-tracking git-stash
