
_kicad_complete() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=()
    local -a matches=()

    while IFS= read -r f; do
        matches+=("$f")
    done < <(compgen -f -X '!*.kicad_pro' -- "$cur")

    while IFS= read -r dir; do
        local -a pro_files=()
        mapfile -t pro_files < <(find "$dir" -maxdepth 1 -name "*.kicad_pro" 2>/dev/null | sort)
        if [[ ${#pro_files[@]} -gt 0 ]]; then
            matches+=("${pro_files[@]}")
        else
            matches+=("$dir/")
        fi
    done < <(compgen -d -- "$cur")

    if [[ "$cur" == */ ]] && [[ -d "$cur" ]]; then
        local -a pro_files=()
        mapfile -t pro_files < <(find "$cur" -maxdepth 1 -name "*.kicad_pro" 2>/dev/null | sort)
        matches+=("${pro_files[@]}")
    fi

    mapfile -t COMPREPLY < <(printf '%s\n' "${matches[@]}" | sort -u)

    local i
    for i in "${!COMPREPLY[@]}"; do
        [[ "${COMPREPLY[$i]}" != */ ]] && COMPREPLY[$i]+=" "
    done
}


complete -o nospace -F _kicad_complete kicad

