import flixel.addons.display.FlxBackdrop;
import openfl.display.BlendMode;

var forever:Bool = false;

var space:FlxBackdrop;
var clouds:FlxBackdrop;
var mask:FlxBackdrop;
var scroll:FlxBackdrop;

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
}

function together()
{
	forever = !forever;

	FlxTween.cancelTweensOf(scroll);
	FlxTween.tween(scroll, {alpha: forever ? 1 : 0}, (Conductor.stepCrochet / 1000) * 8, {ease: forever ? FlxEase.sineIn : FlxEase.sineOut});
}