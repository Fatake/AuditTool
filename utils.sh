# This function will help standardize running a command
function run_cmd () {
    # Syntaxt will be: run_cmd "[COMMAND]" "[LOGFILE]"
    command="$1"

    # we just assume stderr is a permission thing and give a generic
    # failure message.

    /bin/bash -c "$command" 2>/dev/null
}

