RegMonitor: module
{
	PATH: con "regmonitor.dis";

	ADD, DEL, MOD: con iota;

	init: fn();
	monitor: fn(attrs: list of (string, string)): (int, chan of (int, ref Registries->Service));
};
