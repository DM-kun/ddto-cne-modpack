function onEvent(event)
{
	if(event.event.name.toLowerCase() != 'camera fade') return;

	var camera:FlxCamera = (event.event.params[3].toLowerCase() == 'camhud') ? camHUD : camGame;
	camera.fade(event.event.params[1], (Conductor.stepCrochet / 1000) * event.event.params[2], event.event.params[0]);
}