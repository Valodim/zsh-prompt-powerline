
# this prompt hook replaces the exit status number with its associated signal
# name. we can't know for sure if these return codes are actually caused by the
# signals, but usually they are, since few programs output exit codes > 128 for
# error conditions.

+prompt-exitnames () {

    # nothing to do here
    [[ -z $exstat || $exstat == 0 ]] && return 0

    # find index of the prompt_bit with %? in it
    integer idx=$prompt_bits[(i)*%\?*]
    # there isn't any? oh well.
    (( idx <= $#prompt_bits )) || return 0

    local tmp

    # is this a signal name?
    case $exstat in
        129)  tmp=HUP ;;
        130)  tmp=INT ;;
        131)  tmp=QUIT ;;
        132)  tmp=ILL ;;
        134)  tmp=ABRT ;;
        136)  tmp=FPE ;;
        137)  tmp=KILL ;;
        139)  tmp=SEGV ;;
        141)  tmp=PIPE ;;
        143)  tmp=TERM ;;
    esac

    # assuming we are on an x86 system here
    # this MIGHT get annoying since those are in a range of exit codes
    # programs sometimes use.... we'll see.
    case $exstat in
        19)  tmp=STOP ;;
        20)  tmp=TSTP ;;
        21)  tmp=TTIN ;;
        22)  tmp=TTOU ;;
    esac

    # nothing to do here (again)
    [[ -n $tmp ]] || return 0

    # replace %? with the name
    prompt_bits[$idx]=${${prompt_bits[$idx]}/'%?'/$tmp}

}

# don't override other styles with our own - add it to the list!
() {
    local hooks
    zstyle -a ':prompt:*:ps1' precmd-hooks hooks
    zstyle ':prompt:*:ps1' precmd-hooks $hooks +prompt-exitnames
}
