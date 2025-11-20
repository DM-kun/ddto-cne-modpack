import funkin.backend.system.Flags;

private var daPixelZoom:Float = PlayState.daPixelZoom;

// Made by Demi-kun (yes, I am crediting myself here, since this took me a while to finalize)

function onEvent(event)
{
	if(event.event.name.toLowerCase() != 'change note skin') return;

	var skin:String = event.event.params[3];
	if(skin == null || skin == '') skin = 'default';

	if(event.event.params[4])
	{
		if(event.event.params[0]) changePixelStrumSkin(event.event.params[2], skin);
		if(event.event.params[1]) changePixelNoteSkin(event.event.params[2], skin);
	}
	else
	{
		if(event.event.params[0]) changeStrumSkin(event.event.params[2], skin);
		if(event.event.params[1]) changeNoteSkin(event.event.params[2], skin);
	}
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
		strum.scale.set(daPixelZoom * strum.strumLine.strumScale, daPixelZoom * strum.strumLine.strumScale);
		strum.updateHitbox();

		strum.playAnim(prevAnim);
		//strum.updateHitbox();
	}
}

function changeNoteSkin(strumID:Int, skin:String)
{
	for(note in strumLines.members[strumID].notes)
	{
		final prevAnim:String = (note.animation.name != null ? note.animation.name : 'scroll');
		final newSkin:String = switch(note.noteType)
		{
			case 'Pixel Note' | 'Alt Anim Note' | 'No Anim Note' | '' | null: skin;
			case 'Markov No Anim Note': 'Markov Note';
			default: (Assets.exists(Paths.image('game/pixelUI/notes/' + note.noteType)) ? note.noteType : null);
		};
		if(newSkin == null) continue;

		note.frames = Paths.getFrames('game/notes/' + newSkin);

		switch(note.strumID % 4)
		{
			case 0:
				note.animation.addByPrefix('scroll', 'purple0');
				note.animation.addByPrefix('hold', 'purple hold piece');
				note.animation.addByPrefix('holdend', 'pruple end hold');
				if(note.animation.exists('holdend') != true) // null or false
					note.animation.addByPrefix('holdend', 'purple hold end');
			case 1:
				note.animation.addByPrefix('scroll', 'blue0');
				note.animation.addByPrefix('hold', 'blue hold piece');
				note.animation.addByPrefix('holdend', 'blue hold end');
			case 2:
				note.animation.addByPrefix('scroll', 'green0');
				note.animation.addByPrefix('hold', 'green hold piece');
				note.animation.addByPrefix('holdend', 'green hold end');
			case 3:
				note.animation.addByPrefix('scroll', 'red0');
				note.animation.addByPrefix('hold', 'red hold piece');
				note.animation.addByPrefix('holdend', 'red hold end');
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

function changePixelNoteSkin(strumID:Int, skin:String)
{
	for(note in strumLines.members[strumID].notes)
	{
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

		var noteScale:Float = daPixelZoom * note.strumLine.strumScale;
		note.scale.set(noteScale, noteScale);
		note.antialiasing = false;
		note.updateHitbox();

		note.animation.play(prevAnim, true);
		note.updateHitbox();

		if(note.splash == 'default' || note.splash == 'pixel') note.splash = 'pixel';
		else note.splash = note.splash + '-pixel';
	}
}