import funkin.backend.system.Flags;

function onEvent(event)
{
	if(event.event.name.toLowerCase() != 'set camera speed') return;
	camGame.followLerp = Flags.DEFAULT_CAMERA_FOLLOW_SPEED * event.event.params[0];
}