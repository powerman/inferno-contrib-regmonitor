This limbo module will monitor for added/changed/removed registry(4) services with given attributes and send notification about these events by channel.

Dependencies:
  * http://code.google.com/p/inferno-contrib-logger/
  * http://code.google.com/p/inferno-contrib-hashtable/

Best used with http://code.google.com/p/inferno-contrib-retrymount/ for mounting remote registry. :)


---


To install make directory with this module available in /opt/powerman/regmonitor/, for ex.:

```
# hg clone https://inferno-contrib-regmonitor.googlecode.com/hg/ $INFERNO_ROOT/opt/powerman/regmonitor
```

or in user home directory:

```
$ hg clone https://inferno-contrib-regmonitor.googlecode.com/hg/ $INFERNO_USER_HOME/opt/powerman/regmonitor
$ emu
; bind opt /opt
```