#!/bin/bash


function execurl {
  # Executes the text received fom making a GET request to URL in Bash
  # Usage:
  #   execurl "URL"
  # Args:
  #   URL = The url containing Bash code to execute
  bash <(curl -s "$1")
}

function del-prev-line {
  # Executes tput commands to remove the previous row of terminal text
  # Usage:
  #   del-prev-line
  tput cuu1 && tput el
}

function read-file-header {
  # Reads the first line in a file into a variable (found in /usr/lib/git-core/git-sh-prompt as '__git_eread')
  # Usage:
  #   read-file-header FILE VAR
  # Args:
  #   FILE = path of the file whose header you'd like to store
  #   VAR  = name of the variable in which you'd like to store the header
  test -r "$1" && IFS=$'\r\n' read "$2" <"$1"
}

function clean-text {
  # Returns TEXT, with all backslashes escaped
  # Usage:
  #   clean-text "TEXT"
  # Args:
  #   TEXT = The text containing backslashes that need escaping
  local TEXT="${1?"Missing argument 'TEXT'"}"
  printf '%s\n' "$TEXT" | sed 's/[][\/.^$*~|()]/\\&/g'
}


function is-shell-script {
  # Checks if a file's type is text/x-shellscript
  # Args:
  #   $1 = The file to check
  file -i "$1" | grep -q "text/x-shellscript"
}

function append-path {
  # Appends NEW_PATH_ENTRY to the PATH variable if PATH doesn't already contain it
  # Usage:
  #   prepend-path NEW_PATH_ENTRY
  # Args:
  #   NEW_PATH_ENTRY = The path to append to PATH
  local NEW_PATH_ENTRY=${1?'No path provided'}
  if [ ! -d "$NEW_PATH_ENTRY" ]; then
    echo "$NEW_PATH_ENTRY does not exist" > /dev/stderr
    return 1
  fi
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$PATH:$1" ;;
  esac
  export PATH
}

function prepend-path {
  # Prepend NEW_PATH_ENTRY to the PATH variable if PATH doesn't already contain it
  # Usage:
  #   prepend-path NEW_PATH_ENTRY
  # Args:
  #   NEW_PATH_ENTRY = The path to prepend to PATH
  local NEW_PATH_ENTRY
  NEW_PATH_ENTRY=${1?'No path provided'}
  if [ ! -d "$NEW_PATH_ENTRY" ]; then
    echo "$NEW_PATH_ENTRY does not exist" > /dev/stderr
    return 1
  fi
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
  export PATH
}


function sketchy-wall {
  # Writes MESSAGE to every pseudo-terminal owned by the current user
  # Usage: sketchy-wall [MESSAGE|"MESSAGE"]
  # Args:
  #   MESSAGE = The the message to write to every /dev/pts/* file owned by $UID, either quoted or unquoted.
  #             Passed as "${@[*]}"

  # wall won't let you send yourself a message without the banner unless your EUID is 0
  # fortunately, there is a way around this.
  readarray PTS_LIST <<< "$(find /dev/pts -uid $UID)"
  for user_pts in "${PTS_LIST[@]}"; do
    printf "%s\n" "${@[*]}" > $user_pts
  done
}

function editor-to-cmd {
  # Opens $EDITOR, writing the output to a temp file, then redirects it's contents to the specified PROGRAM
  # Usage: editor-to-cmd [-f|--file] PROGRAM
  # Flags:
  #   -f|--file = If set, the path of the temp file will be used as parameter $1 to execute PROGRAM
  # Args:
  #   PROGRAM   = The the message to write to every /dev/pts/* file owned by $UID
  local AS_FILE TMP_FILE TO_CMD
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -f|--file)
        AS_FILE="true"
        shift
        ;;
      *)
        TO_CMD="${1?'No command to redirect editor output to'}"
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
