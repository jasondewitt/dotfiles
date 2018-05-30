# send a notification when command completes
function alert {
    RVAL=$?                           # get return value of the last command
    DATE=`date`                     # get time of completion
    LAST=$history[$HISTCMD] # get current command
    LAST=${LAST%[;&|]*}      # remove "; alert" from it

    # set window title so we can get back to it
    echo -ne "\e]2;$LAST\a"

    LAST=${LAST//\"/'\"'}        # replace " for \" to not break lua format

    # check if the command was successful
    if [[ $RVAL == 0 ]]; then
        RVAL="SUCCESS"
        BG_COLOR="#535d9a"
    else
        RVAL="FAILURE"
        BG_COLOR="#ff2000"
    fi

    # compose the notification
    MESSAGE="naughty.notify({ \
            title = \"Command completed on: \t\t$DATE\", \
            text = \"$ $LAST\" .. newline .. \"$RVAL\", \
            timeout = 0, \
            screen = 2, \
            bg = \"$BG_COLOR\", \
            fg = \"#ffffff\", \
            margin = 8, \
            width = 382, \
            run = function () run_or_raise(nill, { name = \"$LAST\" }) end
            })"
    # send it to awesome
    echo $MESSAGE | awesome-client -
}
