import funkin.backend.system.Flags;

function postCreate()
{
	for(event in events)
	{
		if(event.name != 'Set Camera Speed' || event.time > 10) continue;
		camGame.followLerp = Flags.DEFAULT_CAMERA_FOLLOW_SPEED * event.params[0];
	}
}

function onEvent(event)
{
	if(event.event.name.toLowerCase() != 'set camera speed') return;
	camGame.followLerp = Flags.DEFAULT_CAMERA_FOLLOW_SPEED * event.event.params[0];
}