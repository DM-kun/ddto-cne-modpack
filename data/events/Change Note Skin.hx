import funkin.backend.system.Flags;
import flixel.util.FlxSort;

private var skinEvents = [];

// Made by Demi-kun
// Please credit if used since this took me a while to finalize!

function postCreate()
{
	for(event in events)
	{
		if(event.name != 'Change Note Skin') continue;
		skinEvents.push(event);
	}

	skinEvents.sort(function(p1, p2) {
		return FlxSort.byValues(-1, p1.time, p2.time);
	});

	for(event in skinEvents)
	{
		var strumID:Int = event.params[2];
		var skin:String = event.params[3];
		if(skin == null || skin == '') skin = 'default';

		var endTime:Float = -1;
		for(nextEvent in skinEvents)
		{
			if(nextEvent.time <= event.time || nextEvent.params[2] != strumID) continue;
			endTime = nextEvent.time;
			break;
		}

		if(event.params[4])
		{
			if(event.time <= 10 && event.params[0]) changePixelStrumSkin(strumID, skin);
			if(event.params[1]) changePixelNoteSkin(strumID, skin, event.time, endTime);
		}
		else
		{
			if(event.time <= 10 && event.params[0]) changeStrumSkin(strumID, skin);
			if(event.params[1]) changeNoteSkin(strumID, skin, event.time, endTime);
		}
	}
}

function onEvent(event)
{
	if(event.event.name.toLowerCase() != 'change note skin') return;
	if(!event.event.params[0]) return;

	var skin:String = event.event.params[3];
	if(skin == null || skin == '') skin = 'default';

	if(event.event.params[4]) changePixelStrumSkin(event.event.params[2], skin);
	else changeStrumSkin(event.event.params[2], skin);
}

function changeStrumSkin(strumID:Int, skin:String)
{
	for(strum in strumLines.members[strumID].members)
	{
		final prevAnim:String = (strum.animation.name != null ? strum.animation.name : 'static');

		strum.frames = Paths.getFrames('game/notes/' + skin);

		strum.animation.addByPrefix('purple', 'arrowLEFT');
		strum.animation.addByPrefix('blue', 'arrowDOWN');
		strum.animation.addByPrefix('green', 'arrowUP');
		strum.animation.addByPrefix('red', 'arrowRIGHT');

		strum.antialiasing = Options.antialiasing;
		strum.setGraphicSize(Std.int((strum.width * Flags.DEFAULT_NOTE_SCALE) * strum.strumLine.strumScale));

		final animPrefix:String = strum.strumLine.strumAnimPrefix[strum.ID % strum.strumLine.strumAnimPrefix.length];
		strum.animation.addByPrefix('static', 'arrow' + animPrefix.toUpperCase());
		strum.animation.addByPrefix('pressed', animPrefix + ' press', 24, false);
		strum.animation.addByPrefix('confirm', animPrefix + ' confirm', 24, false);
		strum.updateHitbox();

		strum.playAnim(prevAnim);
		//strum.updateHitbox();
	}
}

function changePixelStrumSkin(strumID:Int, skin:String)
{
	for(strum in strumLines.members[strumID].members)
	{
		final prevAnim:String = (strum.animation.name != null ? strum.animation.name : 'static');

		strum.loadGraphic(Paths.image('game/pixelUI/notes/' + skin), true, 17, 17);
		var maxCol:Int = Math.floor(strum.graphic.width / 17);
		var strumID:Int = strum.ID % maxCol;

		strum.animation.add('static', [strumID]);
		strum.animation.add('pressed', [maxCol + strumID, (maxCol * 2) + strumID], 12, false);
		strum.animation.add('confirm', [(maxCol * 3) + strumID, (maxCol * 4) + strumID], 12, false);

		strum.antialiasing = false;
		strum.scale.set(PlayState.daPixelZoom * strum.strumLine.strumScale, PlayState.daPixelZoom * strum.strumLine.strumScale);
		strum.updateHitbox();

		strum.playAnim(prevAnim);
		//strum.updateHitbox();
	}
}

function changeNoteSkin(strumID:Int, skin:String, startTime:Float, endTime:Float)
{
	for(note in strumLines.members[strumID].notes)
	{
		if(note.strumTime < startTime) continue;
		if(endTime != -1 && note.strumTime > endTime) continue;

		final prevAnim:String = (note.animation.name != null ? note.animation.name : 'scroll');
		final newSkin:String = switch(note.noteType)
		{
			case 'Pixel Note' | 'Alt Anim Note' | 'No Anim Note' | '' | null: skin;
			case 'Markov No Anim Note': 'Markov Note';
			default: (Assets.exists(Paths.image('game/notes/' + note.noteType)) ? note.noteType : null);
		};
		if(newSkin == null) continue;

		note.frames = Paths.getFrames('game/notes/' + newSkin);

		for(i => col in ['purple', 'blue', 'green', 'red'])
		{
			if(i != note.strumID % 4) continue;

			note.animation.addByPrefix('scroll', col + '0');
			note.animation.addByPrefix('hold', col + ' hold piece');
			note.animation.addByPrefix('holdend', col + ' hold end');

			if(col == 'purple' && note.animation.exists('holdend') != true)
				note.animation.addByPrefix('holdend', 'pruple end hold');
		}

		var noteScale:Float = note.strumLine.strumScale * Flags.DEFAULT_NOTE_SCALE;
		note.scale.set(noteScale, noteScale);
		note.antialiasing = Options.antialiasing;
		note.updateHitbox();

		note.animation.play(prevAnim, true);
		note.updateHitbox();

		if(note.splash == 'default' || note.splash == 'pixel') note.splash = 'default';
		else note.splash = note.splash.split('-pixel')[0];
	}
}

function changePixelNoteSkin(strumID:Int, skin:String, startTime:Float, endTime:Float)
{
	for(note in strumLines.members[strumID].notes)
	{
		if(note.strumTime < startTime) continue;
		if(endTime != -1 && note.strumTime > endTime) continue;

		final prevAnim:String = (note.animation.name != null ? note.animation.name : 'scroll');
		final newSkin:String = switch(note.noteType)
		{
			case 'Pixel Note' | 'Alt Anim Note' | 'No Anim Note' | '' | null: skin;
			case 'Markov No Anim Note': 'Markov Note';
			default: (Assets.exists(Paths.image('game/pixelUI/notes/' + note.noteType)) ? note.noteType : null);
		};
		if(newSkin == null) continue;

		if(note.isSustainNote)
		{
			note.loadGraphic(Paths.image('game/pixelUI/notes/' + newSkin + 'ENDS'), true, 7, 6);
			var maxCol:Int = Math.floor(note.graphic.width / 7);
			note.animation.add('hold', [note.strumID % maxCol]);
			note.animation.add('holdend', [maxCol + note.strumID % maxCol]);
		}
		else
		{
			note.loadGraphic(Paths.image('game/pixelUI/notes/' + newSkin), true, 17, 17);
			var maxCol:Int = Math.floor(note.graphic.width / 17);
			note.animation.add('scroll', [maxCol + note.strumID % maxCol]);
		}

		var noteScale:Float = PlayState.daPixelZoom * note.strumLine.strumScale;
		note.scale.set(noteScale, noteScale);
		note.antialiasing = false;
		note.updateHitbox();

		note.animation.play(prevAnim, true);
		note.updateHitbox();

		if(note.splash == 'default' || note.splash == 'pixel') note.splash = 'pixel';
		else note.splash = note.splash + '-pixel';
	}
}