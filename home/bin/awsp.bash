# From https://gist.github.com/oofnikj/f45f25c5bd52a182cf480def3f2a95aa
awsp() {
    if [[ -z $1 ]] ; then
      unset AWS_PROFILE
    fi
    grep -q -w "\[profile ${1}\]" ~/.aws/config || { echo "No such profile $1"; return 1; }
    export AWS_PROFILE=$1
}
_awsp() {
    COMPREPLY=()
    local word="${COMP_WORDS[COMP_CWORD]}"
    if [ "$COMP_CWORD" -eq 1 ]; then
        COMPREPLY=( $(compgen -W "$(grep -E '\[profile .+]' ~/.aws/config | sed -E 's/\[profile (.+)\]/\1/g' | sort)" -- "$word") )
    else
        COMPREPLY=()
    fi
}
complete -F _awsp awsp
