var useTemps:Bool = false;

function postCreate()
{
	if(!useTemps) return;

	var gfTemp:Character = new Character(400, 130, 'gf-doki', false);
	gfTemp.cameras = [charCamera];
	gfTemp.alpha = 0.25;
	add(gfTemp);

	var dadTemp:Character = new Character(100, 100, 'monika', false);
	dadTemp.cameras = [charCamera];
	dadTemp.alpha = 0.25;
	add(dadTemp);

	var bfTemp:Character = new Character(770, 100, 'bf-doki', true);
	bfTemp.cameras = [charCamera];
	bfTemp.alpha = 0.25;
	add(bfTemp);
}

function postUpdate()
{
	if(character != null)
		character.scrollFactor.set(1, 1);
}