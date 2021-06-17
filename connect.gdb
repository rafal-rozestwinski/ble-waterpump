target extended-remote localhost:3333
set remote hardware-breakpoint-limit 4
set remote hardware-watchpoint-limit 2
b main
monitor reset halt
#load
#continue
