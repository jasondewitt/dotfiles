#!/usr/bin/env python

import i3ipc
import json

i3 = i3ipc.Connection()

def on_focus(i3, e):
    current = i3.get_tree().find_focused()
    current_ws_name = current.workspace().name

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

#i3.on('workspace::focus', on_focus)

def find_output(o):
    pass


tree = i3.get_tree()
print(type(tree))
print()
print(vars(tree))
print()
print(dir(tree))
print()

for node in tree.nodes:
    print(dir(node))
    print()


#print('*** outputs ***')
#outputs = i3.get_outputs()
#for o in outputs:
#    print(type(o))

#print('*** workspaces ***')
#workspaces = i3.get_workspaces()
#for ws in workspaces:
#    print(type(ws))

#i3.main()
