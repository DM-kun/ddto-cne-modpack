function onEvent(event)
{
	if(event.event.name.toLowerCase() != 'run haxe code') return;

	__script__.interp.execute(__script__.parser.parseString(event.event.params[0]));
}