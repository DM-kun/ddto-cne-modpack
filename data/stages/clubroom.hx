import openfl.display.BlendMode;

var staticShock:FlxSprite;
var vignette:FlxSprite;
var bakaDoodles:FlxSprite;

var curBaka:String = 'normal';

function postCreate()
{
	lights.blend = BlendMode.SCREEN;

	if(PlayState.SONG.meta.name.toLowerCase() == 'baka' || PlayState.SONG.meta.name.toLowerCase() == 'hot-air-balloon' || PlayState.SONG.meta.name.toLowerCase() == 'home')
	{
		bakaDoodles = new FlxSprite();
		bakaDoodles.frames = Paths.getSparrowAtlas('stages/clubroom/baka-doodles');
		bakaDoodles.animation.addByPrefix('normal', 'Normal Overlay', 24, true);
		bakaDoodles.animation.addByPrefix('rock', 'Rock Overlay', 24, true);
		bakaDoodles.animation.addByPrefix('tank', 'Tank Overlay', 24, true);
		bakaDoodles.animation.addByPrefix('evil', 'HOME Overlay', 24, false);
		bakaDoodles.animation.play('normal');
		bakaDoodles.antialiasing = Options.antialiasing;
		bakaDoodles.cameras = [camHUD];
		bakaDoodles.setGraphicSize(FlxG.width);
		bakaDoodles.updateHitbox();
		bakaDoodles.screenCenter();
		bakaDoodles.alpha = 0;
		add(bakaDoodles);
	}

	if(PlayState.SONG.meta.name.toLowerCase() == 'my-confession' || PlayState.SONG.meta.name.toLowerCase() == 'obsession')
	{
		staticShock = new FlxSprite();
		staticShock.frames = Paths.getSparrowAtlas('stages/clubroom/static-shock');
		staticShock.animation.addByPrefix('loop', 'hueh', 24, true);
		staticShock.animation.play('loop');
		staticShock.antialiasing = Options.antialiasing;
		staticShock.cameras = [camOther];
		staticShock.setGraphicSize(FlxG.width, FlxG.height);
		staticShock.updateHitbox();
		staticShock.screenCenter();
		staticShock.blend = BlendMode.SUBTRACT;
		staticShock.alpha = 0.6;
		staticShock.visible = false;
		add(staticShock);

		vignette = new FlxSprite(0, 0, Paths.image('game/vig-dark'));
		vignette.antialiasing = true;
		vignette.cameras = [camOther];
		vignette.setGraphicSize(FlxG.width, FlxG.height);
		vignette.updateHitbox();
		vignette.screenCenter();
		vignette.alpha = 0;
		add(vignette);
	}
}

function sayonara(happy:String)
{
	if(staticShock == null || vignette == null) return;

	camZooming = (happy != '1');
	staticShock.visible = (happy == '1');
	vignette.alpha = (happy == '1') ? 0.2 : 0;
}

function baka(idiot:String, fade:String, duration:String)
{
	if(bakaDoodles == null || idiot == null) return;

	if(fade == null) fade = '1';
	if(duration == null) duration = '4';
	var fadeFloat:Float = Std.parseFloat(fade);
	var durationInt:Int = Std.parseInt(duration);

	FlxTween.cancelTweensOf(bakaDoodles);
	FlxTween.tween(bakaDoodles, {alpha: fadeFloat}, (Conductor.stepCrochet / 1000) * durationInt, {ease: fadeFloat > 0.5 ? FlxEase.sineIn : FlxEase.sineOut});
	bakaDoodles.animation.play(idiot, true);

	if(curBaka == idiot) return;

	switch(idiot)
	{
		case 'rock': FlxG.camera.shake(0.002, (Conductor.stepCrochet / 1000) * durationInt);
		case 'tank': FlxG.camera.flash(FlxColor.WHITE, (Conductor.stepCrochet / 1000) * durationInt);
		case 'evil': FlxG.camera.fade(FlxColor.WHITE, 0.0001, false);
	}

	curBaka = idiot;
}