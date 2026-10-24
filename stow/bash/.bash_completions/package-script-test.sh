_package_script_test_completion() {
    local IFS=$'
'
    COMPREPLY=( $( env COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   _PACKAGE_SCRIPT_TEST_COMPLETE=complete_bash $1 ) )
    return 0
}

complete -o default -F _package_script_test_completion package-script-test