# cecho - "color echo"
# ex: cecho red ...
# ex: cecho green ...
# ex: cecho yellow ...
function cecho {
    case $1 in
        red)    tput setaf 1 ; shift ;;
        green)  tput setaf 2 ; shift ;;
        yellow) tput setaf 3 ; shift ;;
    esac
    echo -e "$@"
    tput sgr0
}

# suppress - hide command output unless it failed; and if so show in red
# ex: suppress command_that_might_fail args ...
function suppress {
    set +e
    result=$("$@")
    if [ $? -ne 0 ]; then
        cecho red "$result" >&2
        exit 1
    fi
    set -e
}
