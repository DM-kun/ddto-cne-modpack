import funkin.backend.MusicBeatState;
import lime.system.System;

var libbie:Bool = false;
var crashDeath:Bool = false;

function create(event)
{
	crashDeath = StringTools.endsWith(event.lossSFX, '-crash');

	switch(PlayState.SONG.meta.name.toLowerCase())
	{
		case 'libitina':
			event.cancel();
			libbie = true;

			FlxTween.cancelTweensOf(FlxG.camera);
			FlxG.camera.zoom = 1;

			var cover:FlxSprite = new FlxSprite(0, 0, Paths.image('game/gameOver/libitina'));
			cover.antialiasing = Options.antialiasing;
			cover.scrollFactor.set(0, 0);
			add(cover);

			Conductor.changeBPM(gameOverSongBPM);
			CoolUtil.playMusic(Paths.music(gameOverSong), false, 1, true, 100);
			cancelConductorUpdate = true;

		case 'markov':
			FlxTween.cancelTweensOf(FlxG.camera);
			FlxG.camera.zoom = 0.9;

		case 'epiphany':
			FlxTween.cancelTweensOf(FlxG.camera);
			FlxTween.tween(FlxG.camera, {zoom: 0.9}, 0.3, {ease: FlxEase.sineInOut});
	}
}

function postCreate()
{
	if(!crashDeath) return;

	lossSFX = FlxG.sound.play(Paths.sound(lossSFXName));
	Conductor.changeBPM(gameOverSongBPM);
	cancelConductorUpdate = true;

	character.playAnim('crash', true);
}

function update()
{
	if(libbie)
	{
		if(controls.ACCEPT) endBullshit();
		if(controls.BACK) exit();
	}
	else
	{
		if(crashDeath && !lossSFX.playing)
			System.exit(0);
	}
}

function onEnd(event)
{
	event.cancel();

	if(libbie)
	{
		MusicBeatState.skipTransOut = true;
		FlxG.switchState(new PlayState());
		return;
	}

	character.playAnim('deathConfirm', true);
	if(FlxG.sound.music != null) FlxG.sound.music.stop();
	FlxG.sound.music = null;

	var sound = FlxG.sound.play(Paths.sound(retrySFX));
	var secsLength:Float = sound.length / 1000;
	var waitTime = 0.7;
	var fadeOutTime = secsLength - 0.7;

	if(fadeOutTime < 0.5)
	{
		fadeOutTime = secsLength;
		waitTime = 0;
	}

	new FlxTimer().start(waitTime, function(tmr:FlxTimer)
	{
		FlxG.camera.fade(FlxColor.BLACK, fadeOutTime, false, function() {
			MusicBeatState.skipTransOut = true;
			FlxG.switchState(new PlayState());
		});
	});
}