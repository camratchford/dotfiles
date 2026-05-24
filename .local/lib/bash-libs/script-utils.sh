#!/bin/bash

# Executes bash code from the internet
# Args:
#   $1 = URL
function execurl {
  bash <(curl -s "$1")
}

# Executes tput commands to remove the previous row of terminal text
function del-prev-line {
  tput cuu1 && tput el
}

# Reads the first line in a file into a variable (found in /usr/lib/git-core/git-sh-prompt as '__git_eread')
# Args:
#   $1 = path of the file whose header you'd like to store
#   $2 = name of the variable in which you'd like to store the header
function read-file-header {
  test -r "$1" && IFS=$'\r\n' read "$2" <"$1"
}

# Escapes all backslashes
# Args:
#   $1 = The text containing backslashes that need escaping
function clean-text {
  local TEXT="${1?"Missing argument 'TEXT'"}"
  printf '%s\n' "$TEXT" | sed 's/[][\/.^$*~|()]/\\&/g'
}


function is-shell-script {
  file -i "$1" | grep -q "text/x-shellscript"
}

function append-path {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$PATH:$1" ;;
  esac
  export PATH
}

# wall won't let you send yourself a message without the banner unless your EUID is 0
# fortunately, there is a way around this.
function sketchy-wall {
  readarray PTS_LIST <<< "$(find /dev/pts -uid $UID)"
  for user_pts in "${PTS_LIST[@]}"; do
    "%s %s\n" "To $user_pts" "$1" > $user_pts
  done
}

function editor-to-cmd {
  local AS_FILE TMP_FILE TO_CMD
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -f|--file)
        AS_FILE="true"
        shift
        ;;
      *)
        TO_CMD="${1?'No command to pipe editor input from'}"
        shift
        break
        ;;
    esac
  done


  TMP_FILE=$(mktemp -q) && {
    tput smcup
    $EDITOR "$TMP_FILE"
    if [[ ! -s "$TMP_FILE" ]]; then
      rm "$TMP_FILE"
      return 1
    fi
    if [ -n "$AS_FILE" ]; then
      $TO_CMD "$TMP_FILE"
    else
      $TO_CMD < "$TMP_FILE"
    fi
  }
  rm "$TMP_FILE"
  tput rmcup
}

# Parses the caller function's script file for leading comments, printing them out.
function get-help {
  local file="${1:-${BASH_SOURCE[0]}}"
  local func_name="${FUNCNAME[1]}"

  # Require a function name (must be called from inside another function)
  if [[ -z "${func_name}" || "${func_name}" == "main" ]]; then
    echo "help: must be called from within a function" >&2
    return 1
  fi

  if [[ ! -r "${file}" ]]; then
    echo "help: cannot read file: ${file}" >&2
    return 1
  fi

  local func_line
  func_line=$(grep -n "^[[:space:]]*\(function[[:space:]]\+\)\?${func_name}[[:space:]]*(" "${file}" \
    | head -1 | cut -d: -f1)

  if [[ -z "${func_line}" ]]; then
    echo "help: function '${func_name}' not found in ${file}" >&2
    return 1
  fi

  local comments=()
  local i=$(( func_line - 1 ))
  while [[ ${i} -gt 0 ]]; do
    local line
    line=$(sed -n "${i}p" "${file}")
    if [[ "${line}" =~ ^[[:space:]]*#(.*) ]]; then
      comments=("${BASH_REMATCH[1]# }" "${comments[@]}")
    else
      break
    fi
    i=$(( i - 1 ))
  done

  if [[ ${#comments[@]} -eq 0 ]]; then
    echo "(no help comments found for '${func_name}')"
    return 0
  fi

  printf '%s\n' "${comments[@]}"
}
