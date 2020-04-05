#!/bin/bash

if [ ! -e /tmp/status_state ]; then
    touch /tmp/status_state
fi
if [ ! -e /tmp/desk_state ]; then
    touch /tmp/desk_state
fi


(                                         
    flock --nonblock 666 || exit 0        

    while [ 1 ]; do
        if nm-online --quiet --exit; then     
            hit=0
            zoom=`wmctrl -l | grep 'Zoom' | grep -v "Chrome" | wc -l | cut -f 1`
            if [ -e /tmp/dnd ]; then
                hit=1
            fi

            if [ "$zoom" -gt 1 ]; then
                hit=1
            fi

            if [ $hit -eq 1 ]; then
                if [ ! -e '/tmp/status_on' ]; then
                    state=`hue --json lights 10 | grep -E \
                    '"(bri|hue|sat|on)"' | tr -d "\n"`
                    echo -n '{' > /tmp/status_state
                    echo -n ${state%?} >> /tmp/status_state
                    echo -n '}' >> /tmp/status_state
                    
                    state=`hue --json lights 15 | grep -E \
                    '"(bri|hue|sat|on)"' | tr -d "\n"`
                    echo -n '{' > /tmp/desk_state
                    echo -n ${state%?} >> /tmp/desk_state
                    echo -n '}' >> /tmp/desk_state
                    
                    hue lights 10,15 on
                    hue lights 10,15 +254
                    hue lights 10,15 red
                    touch /tmp/status_on
                fi
            fi

            if [ $hit -eq 0 ]; then
                if [ -e '/tmp/status_on' ]; then
                    rm /tmp/status_on
                    device_on=`grep '"on": false' /tmp/status_state | wc -l | cut -f 1`
                    if [ "$device_on" -eq 0 ]; then
                        hue lights 10 on
                        cat /tmp/status_state | hue lights 10 state
                    else 
                        hue lights 10 off
                    fi

                    device_on=`grep '"on": false' /tmp/desk_state | wc -l | cut -f 1`
                    if [ "$device_on" -eq 0 ]; then
                        hue lights 15 on
                        cat /tmp/desk_state | hue lights 15 state
                    else 
                        hue lights 15 off
                    fi
                    rm /tmp/desk_state
                    rm /tmp/status_state
                    
                fi
            fi

        fi                                    

        count=0
        while [ "$count" -lt 2 ]; do
            if [ -e /tmp/dnd ]; then
                count=2
            fi
            sleep 5
            count=`echo $count+1|bc`
        done        
    
    done

) 666>/var/lock/hue-control.lock          
                                          
