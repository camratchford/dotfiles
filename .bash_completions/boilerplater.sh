_boilerplater_completion() {
    local IFS=$'
'
    # shellcheck disable=SC2207
    COMPREPLY=($(  env COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   _BOILERPLATER_COMPLETE=complete_bash $1))
    return 0
}
if which boilerplater &> /dev/null; then
  complete -o default -F _boilerplater_completion boilerplater
fi
