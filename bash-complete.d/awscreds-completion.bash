_awscreds () {
    local cur prev opts base
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    #
    #  The basic options we'll complete.
    #
    #opts="console create list"


    #
    #  Complete the arguments to some of the basic commands.
    #
    case "${prev}" in
        awscreds)
            local running="$(ls ~/aws/creds) unset"
            COMPREPLY=( $(compgen -W "${running}" -- ${cur}) )
            return 0
            ;;
        *)
        ;;
    esac

   return 0
}
complete -F _awscreds awscreds