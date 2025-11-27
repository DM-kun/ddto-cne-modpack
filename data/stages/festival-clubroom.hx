var bloomShader:CustomShader = new CustomShader('bloom');

function create()
{
	bloomShader.range = 0.1;
	bloomShader.steps = 0.005;
	bloomShader.threshhold = 0.8;
	bloomShader.brightness = 7.0;
}

function postCreate()
{
	camGame.addShader(bloomShader);

	for(strumLine in strumLines.members)
	{
		for(character in strumLine.characters)
			character.color = 0xFF828282;
	}
}

function onPostCountdown(event)
{
	if(event.sprite == null) return;
	event.sprite.color = 0xFFC9C9C9;
}

function onPostNoteHit()
{
	comboGroup.forEachAlive(function(spr) {
		spr.color = 0xFFC9C9C9;
	});
}

function destroy()
{
	camGame.removeShader(bloomShader);
}