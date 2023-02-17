#!/usr/bin/env bash
#
# A template for creating command line scripts taking options, commands
# and arguments.
#
# Exit values:
#  0 on success
#  1 on failure
#

# Name of the script
SCRIPT=$( basename "$0" )

# Current version
VERSION="1.0.0"

#
# Message to display for usage and help.
#
function usage {
  local txt=(
    "Utility $SCRIPT for doing stuff."
    "Usage: $SCRIPT [options] <command> [arguments]"
    ""
    "Command:"
    "  milk             Present a daily quote and print it out nicely"
    "  moose [anything]  Present a online daily quote and print it out nicely"
    ""
    "Options:"
    "  --help, -h     Print help."
    "  --version, -v  Print version."
  )

  printf '%s\n' "${txt[@]}"
}

#
# Message to display when bad usage.
#
function badUsage {
  local message="$1"
  local txt=(
    "For an overview of the command, execute:"
    "$SCRIPT --help"
  )

  [[ -n $message ]] && printf '%s\n' "$message"

  printf '%s\n' "${txt[@]}"
}

#
# Message to display for version.
#
function version {
  local txt=(
    "$SCRIPT version $VERSION"
  )

  printf '%s\n' "${txt[@]}"
}

#
# Function that prints daily quote.
#
function app-milk {
  quote=$(fortune)
  cowsay -f milk.cow "$quote"
}

#
# Function that uses online quote service 
# to get a daily quote.
#
function app-moose {
  quote=$(curl -s "https://api.quotable.io/random" | jq -r '.content')
  cowsay -f moose.cow "$quote"
}

#
# Check if required commands are installed
#
function check-commands {
  local commands=(jq cowsay fortune)
  local os=$(uname)

  for cmd in "${commands[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
      case "$os" in
        Linux)
          apt-get install -y "$cmd"
          ;;
        Darwin)
          brew install "$cmd"
          ;;
        *)
          echo "Unknown operating system: $os"
          exit 1
          ;;
      esac
    fi
  done
}

check-commands

#
# Process options
#
while (( $# )); do
  case "$1" in
    --help | -h)
      usage
      exit 0
      ;;
    --version | -v)
      version
      exit 0
      ;;
    milk | moose)
      command=$1
      shift
      app-"$command" "$*"
      exit 0
      ;;
    *)
      badUsage "Option/command not recognized."
      exit 1
      ;;
  esac
done

badUsage
exit 1
