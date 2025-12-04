import flixel.addons.display.FlxBackdrop;
import WiggleEffect;

var finaleSky:FlxBackdrop;
var redStatic:FlxSprite;

var wiggleBack:WiggleEffect;
var wiggleSchool:WiggleEffect;
var wiggleOther:WiggleEffect;

function create()
{
	finaleSky = new FlxBackdrop(Paths.image('stages/school/evil/finaleSky'));
	finaleSky.antialiasing = false;
	finaleSky.scrollFactor.set(0.1, 0.1);
	finaleSky.velocity.set(-10, 0);
	finaleSky.scale.set(6, 6);
	finaleSky.updateHitbox();
	insert(members.indexOf(finaleBG) - 1, finaleSky);

	if(Options.gameplayShaders)
	{
		wiggleBack = new WiggleEffect(1.6, 1.6, 0.011, 0);
		wiggleSchool = new WiggleEffect(2, 4, 0.017, 0);
		wiggleOther = new WiggleEffect(2, 4, 0.007, 0);

		backTrees.shader = wiggleBack.shader;
		school.shader = wiggleSchool.shader;
		street.shader = wiggleOther.shader;
		trees.shader = wiggleOther.shader;
	}
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

	if(PlayState.SONG.meta.name.toLowerCase() == 'dual-demise')
		stageEvent('1');
}

function update(elapsed:Float)
{
	if(wiggleBack != null) wiggleBack.update(elapsed);
	if(wiggleSchool != null) wiggleSchool.update(elapsed);
	if(wiggleOther != null) wiggleOther.update(elapsed);
}

function stageEvent(param:String)
{
	switch(param)
	{
		case "2": petals.visible = true;
		default:
			if(redStatic != null)
			{
				FlxTween.cancelTweensOf(redStatic);
				redStatic.alpha = 1;
				FlxTween.tween(redStatic, {alpha: 0}, 0.2);
			}

			for(obj in [sky, backTrees, school, street, trees]) obj.visible = (param != "1");
			for(obj in [finaleSky, finaleBG, finaleFloor]) obj.visible = (param == "1");
			petals.visible = false;
	}
}

function destroy()
{
	wiggleBack = null;
	wiggleSchool = null;
	wiggleOther = null;
}