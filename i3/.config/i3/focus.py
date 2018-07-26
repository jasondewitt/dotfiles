#!/home/jason/.pyenv/versions/base/bin/python

import i3ipc
import json

i3 = i3ipc.Connection()

def on_focus(i3, e):
    current = i3.get_tree().find_focused()
    current_ws_name = current.workspace().name
    #print(type(i3.get_workspaces()))
    ws_list = i3.get_workspaces()
    for ws in ws_list:
        if ws.name == current_ws_name:
            if ws.output == 'DP-4':
                i3.command("mode default")
            elif ws.output == 'DP-2':
                i3.command('mode monitor2')
            else:
                i3.command('mode default')
            break
#        print(type(ws))

i3.on('workspace::focus', on_focus)

i3.main()
#outputs = json.dumps(i3.get_outputs())
#print(outputs)