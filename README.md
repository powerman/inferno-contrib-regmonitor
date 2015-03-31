# Description

This limbo module will monitor for added/changed/removed registry(4)
services with given attributes and send notification about these events by
channel.

Best used with http://code.google.com/p/inferno-contrib-retrymount/ for
mounting remote registry. :)

# Install

Make directory with this module available in /opt/powerman/regmonitor/.

Install system-wide:

```
# git clone https://github.com/powerman/inferno-contrib-regmonitor.git $INFERNO_ROOT/opt/powerman/regmonitor
```

or in your home directory:

```
$ git clone https://github.com/powerman/inferno-contrib-regmonitor.git $INFERNO_USER_HOME/opt/powerman/regmonitor
$ emu
; bind opt /opt
```

or locally for your project:

```
$ git clone https://github.com/powerman/inferno-contrib-regmonitor.git $YOUR_PROJECT_DIR/opt/powerman/regmonitor
$ emu
; cd $YOUR_PROJECT_DIR_INSIDE_EMU
; bind opt /opt
```

If you want to run commands and read man pages without entering full path
to them (like `/opt/VENDOR/APP/dis/cmd/NAME`) you should also install and
use https://github.com/powerman/inferno-opt-setup 

## Dependencies

* https://github.com/powerman/inferno-contrib-logger
* https://github.com/powerman/inferno-contrib-hashtable


