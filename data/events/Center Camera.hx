function postCreate()
{
	for(event in events)
	{
		if(event.name != 'Center Camera' || event.time > 10) continue;
		onEvent({event: event});
		events.remove(event);
	}
}

function onEvent(e)
{
	var event = e.event;
	if(event.name.toLowerCase() != 'center camera') return;

	var tween = eventsTween.get("cameraMovement");
	if(tween != null)
	{
		if(tween.onComplete != null) tween.onComplete(tween);
		tween.cancel();
	}

	curCameraTarget = -1;
	centerCamera(event.params[0], event.params[1]);

	if(strumLines.members[event.params[0]] == null || strumLines.members[event.params[1]] == null) return;

	if(event.params[2] == false) FlxG.camera.snapToTarget();
	else if(event.params[4] != null && event.params[4] != "CLASSIC")
	{
		var oldFollow = FlxG.camera.followEnabled;
		FlxG.camera.followEnabled = false;
		eventsTween.set("cameraMovement", FlxTween.tween(FlxG.camera.scroll, {x: camFollow.x - FlxG.camera.width * 0.5, y: camFollow.y - FlxG.camera.height * 0.5},
			(Conductor.stepCrochet / 1000) * (event.params[3] == null ? 4 : event.params[3]), {
				ease: CoolUtil.flxeaseFromString(event.params[4], event.params[5]),
				onComplete: (_) -> FlxG.camera.followEnabled = oldFollow
			})
		);
	}
}

function centerCamera(target:Int, target2:Int)
{
	if(strumLines.members[target] == null || strumLines.members[target2] == null) return;

	var data:CamPosData = getStrumlineCamPos(target);
	var data2:CamPosData = getStrumlineCamPos(target2);
	if(data.amount > 0 && data2.amount > 0)
	{
		var camPosX:Float = FlxMath.lerp(data.pos.x, data2.pos.x, 0.5);
		var camPosY:Float = FlxMath.lerp(data.pos.y, data2.pos.y, 0.5);
		PlayState.instance.camFollow.setPosition(camPosX, camPosY);
	}
	data.put();
	data2.put();
}