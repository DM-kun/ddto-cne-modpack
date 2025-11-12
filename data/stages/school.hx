import WiggleEffect;

var redStatic:FlxSprite;

var wiggleBack:WiggleEffect;
var wiggleSchool:WiggleEffect;
var wiggleOther:WiggleEffect;

function create()
{
	if(Options.gameplayShaders)
	{
		wiggleBack = new WiggleEffect(1.6, 1.6, 0.011, 0);
		wiggleSchool = new WiggleEffect(2, 4, 0.017, 0);
		wiggleOther = new WiggleEffect(2, 4, 0.007, 0);

		evilBackTrees.shader = wiggleBack.shader;
		evilSchool.shader = wiggleSchool.shader;
		evilStreet.shader = wiggleOther.shader;
		evilTrees.shader = wiggleOther.shader;
	}

	bgGirls.visible = switch(PlayState.SONG.meta.name.toLowerCase())
	{
		case 'bara-no-yume' | 'poems-n-thorns': true;
		default: false;
	};
}

function postCreate()
{
	stageEvent('0');

	redStatic = new FlxSprite();
	redStatic.frames = Paths.getSparrowAtlas('game/HomeStatic');
	redStatic.animation.addByPrefix('loop', 'HomeStatic', 24, true);
	redStatic.animation.play('loop');
	redStatic.antialiasing = Options.antialiasing;
	redStatic.setGraphicSize(FlxG.width, FlxG.height);
	redStatic.updateHitbox();
	redStatic.screenCenter();
	redStatic.cameras = [camOther];
	redStatic.alpha = 0;
	add(redStatic);
}

function update(elapsed:Float)
{
	if(wiggleBack != null) wiggleBack.update(elapsed);
	if(wiggleSchool != null) wiggleSchool.update(elapsed);
	if(wiggleOther != null) wiggleOther.update(elapsed);
}

function stageEvent(justMonika:String)
{
	if(redStatic != null)
	{
		FlxTween.cancelTweensOf(redStatic);
		redStatic.alpha = 1;
		FlxTween.tween(redStatic, {alpha: 0}, 0.2);
	}

	sky.visible = backTrees.visible = school.visible = street.visible = treesFG.visible = treesBG.visible = petals.visible = (justMonika != '1');
	evilSky.visible = evilBackTrees.visible = evilSchool.visible = evilStreet.visible = evilTrees.visible = (justMonika == '1');
	bgGirls.visible = switch(PlayState.SONG.meta.name.toLowerCase())
	{
		case 'bara-no-yume' | 'poems-n-thorns': (justMonika != '1');
		default: false;
	};
}

function destroy()
{
	wiggleBack = null;
	wiggleSchool = null;
	wiggleOther = null;
}