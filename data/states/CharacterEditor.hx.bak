var useSils:Bool = true;

var curStage:String = "stage";

var silhouettes:Array<FlxSprite> = [];
var gfSil:FlxSprite;
var dadSil:FlxSprite;
var bfSil:FlxSprite;

function create()
{
	if(useSils) return;
	disableScript();
}

function postCreate()
{
	gfSil = new FlxSprite(400, 130, Paths.image('editors/character/silhouettes/gf'));
	gfSil.offset.set(46.5, 27.5);
	silhouettes.push(gfSil);

	dadSil = new FlxSprite(100, 100, Paths.image('editors/character/silhouettes/dad'));
	dadSil.offset.set(-6, 0);
	silhouettes.push(dadSil);

	bfSil = new FlxSprite(770, 100, Paths.image('editors/character/silhouettes/bf'));
	bfSil.offset.set(-7, -350);
	silhouettes.push(bfSil);

	for(silhouette in silhouettes)
	{
		silhouette.active = false;
		silhouette.antialiasing = Options.antialiasing;
		silhouette.cameras = [charCamera];
		silhouette.alpha = 0.25;
	}

	reloadPositions();
}

function update()
{
	if(curStage != currentStage)
		reloadPositions();
}

function reloadPositions()
{
	curStage = currentStage;

	remove(gfSil);
	var gfInfo = stage.characterPoses["girlfriend"];
	gfSil.setPosition(gfInfo.x, gfInfo.y);
	gfSil.scrollFactor.set(gfInfo.scrollFactor.x, gfInfo.scrollFactor.y);
	insert(members.indexOf(character), gfSil);

	remove(dadSil);
	var dadInfo = stage.characterPoses["dad"];
	dadSil.setPosition(dadInfo.x, dadInfo.y);
	dadSil.scrollFactor.set(dadInfo.scrollFactor.x, dadInfo.scrollFactor.y);
	insert(members.indexOf(character), dadSil);

	remove(bfSil);
	var bfInfo = stage.characterPoses["boyfriend"];
	bfSil.setPosition(bfInfo.x, bfInfo.y);
	bfSil.scrollFactor.set(bfInfo.scrollFactor.x, bfInfo.scrollFactor.y);
	insert(members.indexOf(character), bfSil);
}