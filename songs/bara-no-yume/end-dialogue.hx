import hxvlc.flixel.FlxVideoSprite;

var monika:FlxVideoSprite;
var schoolFakeout:FlxSprite;
var playedFakeout:Bool = false;

function postCreate()
{
	schoolFakeout = new FlxSprite();
	schoolFakeout.frames = Paths.getSparrowAtlas('dialogue/cutscenes/animatedEvilSchool');
	schoolFakeout.animation.addByPrefix('idle', 'background 2', 24);
	schoolFakeout.animation.play('idle');
	schoolFakeout.scale.set(6, 6);
	schoolFakeout.updateHitbox();
	schoolFakeout.screenCenter();
	schoolFakeout.antialiasing = false;
	schoolFakeout.visible = false;
	add(schoolFakeout);

	FlxG.sound.load(Paths.sound('cutscene/fakeout'));

	monika = new FlxVideoSprite();
	monika.antialiasing = Options.antialiasing;
	monika.bitmap.onFormatSetup.add(function()
	{
		if(monika.bitmap != null && monika.bitmap.bitmapData != null)
		{
			monika.setGraphicSize(FlxG.width);
			monika.updateHitbox();
			monika.screenCenter();
		}
	});
	monika.bitmap.onEndReached.add(finishFakeout);
	monika.visible = false;
	add(monika);

	monika.load(Paths.video('monika'));
}

function close(event)
{
	if(playedFakeout) return;
	event.cancelled = true;

	FlxG.sound.play(Paths.sound('cutscene/fakeout'));
	schoolFakeout.visible = true;

	new FlxTimer().start(1.8, function(_) {
		monika.visible = true;
		monika.play();
	});
}

function finishFakeout()
{
	playedFakeout = true;
	// for some reason just close(); doesn't work...
	FlxG.state.subState.close();
}