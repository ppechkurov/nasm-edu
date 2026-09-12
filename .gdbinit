set disassembly-flavor intel
set history save on
set print pretty on

python
import os
try:
   gdb.execute("layout asm")
   gdb.execute("layout regs")
except gdb.error:
   pass
tty = os.environ.get("DBG_TTY")
if tty:
   gdb.execute("set inferior-tty " + tty)
end
