implement RegMonitor;

include "sys.m";
	sys: Sys;
	sprint: import sys;
include "../../../logger/module/logger.m";
	logger: Logger;
	log, ERR, WARN, NOTICE, INFO, DEBUG: import logger;
include "registries.m";
	registries: Registries;
	Registry, Service: import registries;
include "../../../hashtable/module/hashtable.m";
	hashtable: HashTable;
	Hash: import hashtable;
include "../../module/regmonitor.m";

prev : ref Hash[ref Service];


init()
{
	sys = load Sys Sys->PATH;
	logger = load Logger Logger->PATH;
	if(logger == nil)
		raise sprint("load: Logger: %r");
	logger->init();
	logger->modname("RegMonitor");

	registries = checkload(load Registries Registries->PATH, "Registries");
	registries->init();	

	hashtable = checkload(load HashTable HashTable->PATH, "HashTable");
}

monitor(attrs: list of (string, string)): (int, chan of (int, ref Service))
{
	event := chan of (int, ref Service);
	spawn regmon(attrs, event, pidc := chan of int);
	return (<-pidc, event);
}

regmon(attrs: list of (string, string), event: chan of (int, ref Service), pidc: chan of int)
{
	log(INFO, "regmon started: "+attrs2s(attrs));
	pidc <-= sys->pctl(0, nil);
	buf := array[Sys->NAMEMAX] of byte;
	for(;;){
	  {
		reg := Registry.new(nil);
		if(reg == nil)
			fail(sprint("Registry.new: %r"));
		e := sys->open(reg.dir+"/event", Sys->OREAD);
		if(e == nil)
			fail(sprint("open event: %r"));
		for(;;){
			(svcs, err) := reg.find(attrs);
			if(err != nil)
				fail("find: " + err);
			diffservices(svcs, event);
			n := sys->read(e, buf, len buf);
			if(n <= 0)
				if(n < 0)
					fail(sprint("read event: %r"));
				else
					fail("read event: EOF");
		}
	  } exception {
		* => sys->sleep(1000);
	  }
	}
}

diffservices(svcs: list of ref Service, event: chan of (int, ref Service))
{
	if(prev == nil)
		prev = Hash[ref Service].new(13);
	curr := Hash[ref Service].new(13);
	for(l := svcs; l != nil; l = tl l){
		addr := (hd l).addr;
		if(prev.get(addr) == nil)
			event <-= (ADD, hd l);
		else
			prev.del(addr);
			# TODO event <-= (MOD, hd l)
		curr.set(addr, hd l);
	}
	for(k := prev.all(); k != nil; k = tl k)
		event <-= (DEL, (hd k).val);
	prev = curr;
}

attrs2s(attrs: list of (string, string)): string
{
	s := "";
	for(; attrs != nil; attrs = tl attrs)
		s += sprint("%s=%s ", (hd attrs).t0, (hd attrs).t1);
	if(s != "")
		s = s[0:len s - 1];
	return s;
}


###

fail(s: string)
{
	log(ERR, s);
	raise "fail:"+s;
}

checkload[T](x: T, s: string): T
{
	if(x == nil)
		fail(sprint("load: %s: %r", s));
	return x;
}


