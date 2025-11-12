function onEvent(event)
{
	if(event.event.name.toLowerCase() != 'set character speed') return;

	for(character in strumLines.members[event.event.params[0]].characters)
	{
		if(character == null) continue;
		character.beatInterval = event.event.params[1];
	}
}