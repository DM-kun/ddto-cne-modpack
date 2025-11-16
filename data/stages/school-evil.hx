import flixel.addons.display.FlxBackdrop;
import WiggleEffect;

var finaleSky:FlxBackdrop;
var redStatic:FlxSprite;

var wiggleBack:WiggleEffect;
var wiggleSchool:WiggleEffect;
var wiggleOther:WiggleEffect;

var bigMonika = null;

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

	if(PlayState.SONG.meta.name.toLowerCase() == 'your-demise')
		bigMonika = strumLines.members[0].characters[1];
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

			var justMonika:Bool = param == "1";
			if(PlayState.SONG.meta.name.toLowerCase() == 'your-demise')
			{
				dad.visible = !justMonika;
				bigMonika.visible = justMonika;

				iconP2.setIcon(justMonika ? bigMonika.getIcon() : dad.getIcon());

				var oppChar = justMonika ? bigMonika : dad;
				var playerColor:Int = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : (opponentMode ? 0xFFFF0000 : 0xFF66FF33);
				var opponentColor:Int = oppChar != null && oppChar.iconColor != null && Options.colorHealthBar ? oppChar.iconColor : (opponentMode ? 0xFF66FF33 : 0xFFFF0000);
				healthBar.createFilledBar(opponentColor, playerColor);
				healthBar.updateBar();

				if(timeBar != null)
				{
					timeBar.createGradientBar([FlxColor.TRANSPARENT], [playerColor, opponentColor]);
					timeBar.updateBar();
				}
			}
			sky.visible = backTrees.visible = school.visible = street.visible = trees.visible = !justMonika;
			finaleSky.visible = finaleBG.visible = finaleFloor.visible = justMonika;
			petals.visible = false;
	}
}

function destroy()
{
	wiggleBack = null;
	wiggleSchool = null;
	wiggleOther = null;
}