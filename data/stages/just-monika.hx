import flixel.addons.display.FlxBackdrop;
import openfl.display.BlendMode;

var forever:Bool = false;

var space:FlxBackdrop;
var clouds:FlxBackdrop;
var mask:FlxBackdrop;
var scroll:FlxBackdrop;

var popup:FlxSprite;

function postCreate()
{
	lights.blend = BlendMode.SCREEN;

	space = new FlxBackdrop(Paths.image('stages/clubroom-evil/sky'));
	space.antialiasing = Options.antialiasing;
	space.scrollFactor.set(0.1, 0.1);
	space.velocity.set(-7, 0);
	space.scale.set(0.7, 0.7);
	space.updateHitbox();
	insert(members.indexOf(clubroom) - 3, space);

	clouds = new FlxBackdrop(Paths.image('stages/clubroom-evil/clouds'));
	clouds.antialiasing = Options.antialiasing;
	clouds.scrollFactor.set(0.1, 0.1);
	clouds.velocity.set(-13, 0);
	clouds.scale.set(0.7, 0.7);
	clouds.updateHitbox();
	insert(members.indexOf(clubroom) - 2, clouds);

	mask = new FlxBackdrop(Paths.image('stages/clubroom-evil/mask'));
	mask.antialiasing = Options.antialiasing;
	mask.scrollFactor.set(0.1, 0.1);
	mask.velocity.set(-13, 0);
	mask.scale.set(0.7, 0.7);
	mask.updateHitbox();
	insert(members.indexOf(clubroom) - 1, mask);

	scroll = new FlxBackdrop(Paths.image('menus/bg'));
	scroll.antialiasing = Options.antialiasing;
	scroll.velocity.set(-40, -40);
	scroll.alpha = 0;
	insert(members.indexOf(table), scroll);

	popup = new FlxSprite(350, 400);
	popup.frames = Paths.getSparrowAtlas('stages/clubroom-evil/monika-delete');
	popup.animation.addByPrefix('idle', 'PopUpAnim', 24, false);
	popup.animation.play('idle');
	popup.antialiasing = Options.antialiasing;
	popup.visible = false;
	insert(members.indexOf(dad) + 1, popup);
}

function together()
{
	forever = !forever;

	FlxTween.cancelTweensOf(scroll);
	FlxTween.tween(scroll, {alpha: forever ? 1 : 0}, (Conductor.stepCrochet / 1000) * 8, {ease: forever ? FlxEase.sineIn : FlxEase.sineOut});
}

function verifyFiles()
{
	popup.visible = true;
	popup.animation.play('idle', true);
}

function deleteMonika()
{
	dad.playAnim((FlxG.save.data.songsBeaten.contains('epiphany') ? 'end-alt' : 'end'), true, 'LOCK');
	dad.animation.onFinish.add(function(anim:String) {
		for(strum in strumLines.members[0].members)
		{
			FlxTween.tween(strum, {alpha: 0}, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.sineOut});
		}
		FlxTween.tween(iconP2, {alpha: 0}, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.sineOut});

		var rightColor:Int = bf != null && bf.iconColor != null && Options.colorHealthBar ? bf.iconColor : (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33);
		healthBar.createFilledBar(FlxColor.BLACK, rightColor);
		healthBar.updateBar();

		if(timeBar != null)
		{
			timeBar.createGradientBar([FlxColor.TRANSPARENT], [rightColor, FlxColor.BLACK]);
			timeBar.updateBar();
		}
	});
}