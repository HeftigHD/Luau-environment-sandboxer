Just an environment sandboxer with a few custom functions seen in exploits
there is a master_controller where you can do whatever you like and use those custom implemented functions to analyse sandboxed code
this can be detected per overflow and potentially per xpcall with a wrap as the error handler and per string functions bc the instances are replaced with newproxy
in Testing there is a script that has the sandboxer call which can be used to sandbox a script

this was made within a week out of boredom
