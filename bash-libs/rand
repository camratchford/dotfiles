#!/bin/bash

function rand-b64 {

  local HELP=$(cat <<EOF
Prints a random integer between a min and max integer

Usage:
    rand-b64 SIZE_INT
    rand-b64 -h

Options:
    -h       Print this message and exit

Arguments:
    SIZE_INT The byte length of the b64-encoded integer you wish to generate
             (Defaults to 16 if no arguments are passed)

Examples:
    rand-b64
    > buyL55f4qGne+XqpqsnaUA

    rand-b64 64
    > 81YJCeyUYQthGARxX5EJFoNIs+pZUgvQimmyeMS5mCCqGkXZBkF38sdfsn88OtUtmev2pCcpuVrlx6J48bdi3Q
EOF
)
  while getopts ":h-:" opt; do
    case "$opt" in
      h)
        printf "%s\n" "$HELP" && return 0
        ;;
      -)
        case "${OPTARG}" in
          help)
            printf "%s\n" "$HELP" && return 0
            ;;
          *)
            echo "Invalid option: --${OPTARG}" >&2 && return 1
            ;;
        esac
        ;;
      \?)
        echo "Invalid option: -$OPTARG" >&2 && return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))

  local NUM_LEN=$1
  if [[ -z "$1" ]]; then
    NUM_LEN=16
  fi
  local RESULT="$(head -c "$NUM_LEN" /dev/urandom | base64 -w 0 | tr -d '=')"
  echo "$RESULT"
}

function rand-int {
  local HELP=$(cat <<EOF
Prints a random integer between a min and max integer

Usage:
    rand-int MIN_INT MAX_INT
    rand-int MAX_INT
    rand-int -h

Options:
    -h       Print this message and exits

Arguments:
    MIN_INT  The lowest possible value that the random number can be (inclusive)
             (Defaults to 0 if only 1 arg (MAX_INT) is passed)

    MAX_INT  The highest possible value plus one that the random number can be (exclusive)
             (Is the 2nd argument if 2 args are passed, is the 1st argument if only 1 arg is passed)

Examples:
    # Produces a random integer in the range of 10 to 100
    rand-int 10 101
    > 28
    # Produces a random integer in the range of 0 to 9
    rand-int 10
    > 9

EOF
)

  while getopts ":h-:" opt; do
    case "$opt" in
      h)
        printf "%s\n" "$HELP"
        return 0
        ;;
      -)
        case "${OPTARG}" in
          help)
            printf "%s\n" "$HELP"
            return 0
            ;;
          *)
            echo "Invalid option: --${OPTARG}" >&2
            return 1
            ;;
        esac
        ;;
      \?)
        echo "Invalid option: -$OPTARG" >&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND - 1))  # Correct shift

  local MIN_NUM=0
  local MAX_NUM

  if [[ -n "$2" ]]; then
    MIN_NUM="$1"
    MAX_NUM="$2"
  else
    MAX_NUM="$1"
  fi

  # Ensure valid numeric inputs
  if ! [[ "$MIN_NUM" =~ ^[0-9]+$ ]] || ! [[ "$MAX_NUM" =~ ^[0-9]+$ ]]; then
    echo "Error: Arguments must be integers." >&2
    return 1
  fi
  if (( MIN_NUM >= MAX_NUM )); then
    echo "Error: MIN_INT must be less than MAX_INT." >&2
    return 1
  fi

  # Generate random 64-bit integer
  local B64_NUM="$(rand-b64 8)"
  local INT_NUM=$(( 0x$(echo "$B64_NUM" | hexdump -v -e '/8 "%016x"') ))

  echo $(( MIN_NUM + INT_NUM % (MAX_NUM - MIN_NUM) ))
}

