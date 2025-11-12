function onEvent(event)
{
	if(event.event.name.toLowerCase() != 'camera fade') return;

	var cam:FlxCamera = (event.event.params[3].toLowerCase() == "camHUD") ? camHUD : camGame;
	camera.fade(event.event.params[1], (Conductor.stepCrochet / 1000) * event.event.params[2], event.event.params[0]);
}