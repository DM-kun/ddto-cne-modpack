function postCreate()
{
	for(event in events)
	{
		if(event.name != 'Camera Fade' || event.time > 10) continue;
		if(!event.params[0]) continue;
		camera.fade(event.params[1], 0.01, false);
	}
}

function onEvent(event)
{
	if(event.event.name.toLowerCase() != 'camera fade') return;

	var camera:FlxCamera = (event.event.params[3].toLowerCase() == 'camhud') ? camHUD : camGame;
	camera.stopFade();
	camera.fade(event.event.params[1], (Conductor.stepCrochet / 1000) * event.event.params[2], event.event.params[0]);
}