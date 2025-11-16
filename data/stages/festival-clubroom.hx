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
			character.color = 0x828282;
	}
}

function destroy()
{
	camGame.removeShader(bloomShader);
}