var pixelShader:CustomShader = new CustomShader('pixel');

function postCreate()
{
	pixelShader.value = 0.0;
	camGame.addShader(pixelShader);
}

function onEvent(event)
{
	if(event.event.name.toLowerCase() != 'pixelize game') return;

	FlxTween.cancelTweensOf(pixelShader);
	FlxTween.tween(pixelShader, {value: event.event.params[0]}, (Conductor.stepCrochet / 1000) * event.event.params[1], {ease: FlxEase.quadOut});
}

function destroy()
{
	camGame.removeShader(pixelShader);
}