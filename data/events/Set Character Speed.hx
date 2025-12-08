function postCreate()
{
	for(event in events)
	{
		if(event.name != 'Set Character Speed' || event.time > 10) continue;
		for(character in strumLines.members[event.params[0]].characters)
		{
			if(character == null) continue;
			character.beatInterval = event.params[1];
		}
	}
}

function onEvent(event)
{
	if(event.event.name.toLowerCase() != 'set character speed') return;

	for(character in strumLines.members[event.event.params[0]].characters)
	{
		if(character == null) continue;
		character.beatInterval = event.event.params[1];
	}
}