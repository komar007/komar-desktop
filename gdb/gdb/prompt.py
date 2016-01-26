import gdb
from gdb.prompt import substitute_prompt

p_tmpl = '\[\e]0;gdb: [{thread}] {frame}\x07\]\[\e[01;31m\]gdb\[\e[01;32m\][\[\e[0m\]{thread}\[\e[01;32m\]] \[\e[0m\]{frame}\[\e[01;34m\]$ \[\e[0m\]'

def render_prompt(cur):
    try:
        frame = gdb.selected_frame()
        f_str = "%s " % frame.name()
    except gdb.error:
        f_str = ""

    t_str = ""
    try:
        thread = gdb.selected_thread()
        if thread is not None:
            t_str = "{num}: {name}".format(num=thread.num, name=thread.name)
    except gdb.error:
        pass

    return substitute_prompt(p_tmpl.format(thread=t_str, frame=f_str))

gdb.prompt_hook = render_prompt
