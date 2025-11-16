import flixel.addons.display.FlxBackdrop;
import openfl.display.BlendMode;

var staticShock:FlxSprite;
var vignette:FlxSprite;

var sparkleBG:FlxBackdrop;
var sparkleFG:FlxBackdrop;
var overlay:FlxSprite;
var crazyYuri = null;

var curBaka:String = 'normal';
var bakaDoodles:FlxSprite;

function postCreate()
{
	lights.blend = BlendMode.SCREEN;
	darkness.alpha = 0;

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

	if(PlayState.SONG.meta.name.toLowerCase() == 'deep-breaths')
	{
		sparkleBG = new FlxBackdrop(Paths.image('stages/clubroom/sparklesBG'));
		sparkleBG.antialiasing = Options.antialiasing;
		sparkleBG.scrollFactor.set(0.2, 0.1);
		sparkleBG.velocity.set(-16, 0);
		sparkleBG.setGraphicSize(Std.int(sparkleBG.width / 0.75));
		sparkleBG.updateHitbox();
		sparkleBG.screenCenter();
		sparkleBG.alpha = 0;
		insert(members.indexOf(tmp), sparkleBG);

		sparkleFG = new FlxBackdrop(Paths.image('stages/clubroom/sparklesFG'));
		sparkleFG.antialiasing = Options.antialiasing;
		sparkleFG.scrollFactor.set(0.1, 0.05);
		sparkleFG.velocity.set(-48, 0);
		sparkleFG.setGraphicSize(Std.int((sparkleFG.width * 1.2) / 0.75));
		sparkleFG.updateHitbox();
		sparkleFG.screenCenter();
		sparkleFG.alpha = 0;
		add(sparkleFG);

		overlay = new FlxSprite().makeSolid(FlxG.width * 3, FlxG.height * 3, 0xFFF281F2);
		overlay.antialiasing = false;
		overlay.scrollFactor.set(0, 0);
		overlay.screenCenter();
		overlay.blend = BlendMode.SCREEN;
		overlay.alpha = 0;
		add(overlay);
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

	if(PlayState.SONG.meta.name.toLowerCase() == 'obsession')
	{
		crazyYuri = strumLines.members[0].characters[1];
		crazyYuri.visible = false;
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

function obsession(yuri:String)
{
	if(PlayState.SONG.meta.name.toLowerCase() == 'deep-breaths')
	{
		if(sparkleBG == null || sparkleFG == null || overlay == null) return;

		var spark:Bool = (yuri == '1');

		for(obj in [sparkleBG, sparkleFG])
		{
			FlxTween.cancelTweensOf(obj);
			FlxTween.tween(obj, {alpha: spark ? 1 : 0}, (Conductor.stepCrochet / 1000) * (spark ? 4 : 16), {ease: spark ? FlxEase.sineIn : FlxEase.sineOut});
		}

		FlxTween.cancelTweensOf(overlay);
		FlxTween.tween(overlay, {alpha: spark ? 0.2 : 0}, (Conductor.stepCrochet / 1000) * (spark ? 4 : 16), {ease: spark ? FlxEase.sineIn : FlxEase.sineOut});
	}

	if(PlayState.SONG.meta.name.toLowerCase() == 'obsession')
	{
		if(staticShock == null || vignette == null) return;

		if(yuri == 'start')
		{
			FlxTween.cancelTweensOf(staticShock);
			staticShock.alpha = 0;
			staticShock.visible = true;
			FlxTween.tween(staticShock, {alpha: 1}, (Conductor.stepCrochet / 1000) * 70, {onComplete: (_) -> staticShock.alpha = 0.1});
		}
		else
		{
			if(crazyYuri != null)
			{
				dad.visible = false;
				crazyYuri.visible = true;
				boyfriend.x = crazyYuri.x + 250;
			}
			else boyfriend.x = dad.x + 250;
			desksFG.visible = false;
			darkness.alpha = 0.8;
			vignette.alpha = 0.6;
		}
	}
}