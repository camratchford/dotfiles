_resume_generator_completion() {
    local IFS=$'
'
    COMPREPLY=( $( env COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   _RESUME_GENERATOR_COMPLETE=complete_bash $1 ) )
    return 0
}

complete -o default -F _resume_generator_completion resume-generator