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
function usage
{
    local txt=(
"Utility $SCRIPT for doing stuff."
"Usage: $SCRIPT [options] <command> [arguments]"
""
"Command:"
"  milk             Present a daily quote and print it out nicely"
"  mosse [anything]  Present a online daily quote and print it out nicely"
"  calendar [events]    Print out current calendar with(out) events."
""
"Options:"
"  --help, -h     Print help."
"  --version, -h  Print version."
    )

    printf "%s\\n" "${txt[@]}"
}

#
# Message to display when bad usage.
#
function badUsage
{
    local message="$1"
    local txt=(
"For an overview of the command, execute:"
"$SCRIPT --help"
    )

    [[ -n $message ]] && printf "%s\\n" "$message"

    printf "%s\\n" "${txt[@]}"
}

#
# Message to display for version.
#
function version
{
    local txt=(
"$SCRIPT version $VERSION"
    )

    printf "%s\\n" "${txt[@]}"
}

#
# Function that prints daily quote.
#
function app-milk
{
    quote=$(fortune)
    cowsay -f milk.cow $quote
}

#
# Function that uses online quote service 
# to do get a daily quote.
#
function app-moose
{
    quote=$(curl -s "https://api.quotable.io/random" | jq '.content' | sed 's/^"\(.*\)"$/\1/')
    cowsay -f moose.cow $quote
}


#
# Process options
#
while (( $# ))
# To detect the OS if jq command is not installed
os=$(uname)

if [[ "$os" == "Linux" ]]; then
    if ! command -v jq &> /dev/null; then
        apt-get install jq -y
    fi 
    if ! command -v cowsay &> /dev/null; then
        apt install cowsay -y
    fi 
    if ! command -v fortune &> /dev/null; then
        apt install fortune-mod -y
    fi 
elif [[ "$os" == "Darwin" ]]; then
    if ! command -v jq &> /dev/null; then
        brew install jq
    fi
    if ! command -v cowsay &> /dev/null; then
        brew install cowsay
    fi 
    if ! command -v fortune &> /dev/null; then
        brew install fortune
    fi
else
    echo "Unknown operating system: $os"
fi




do
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
