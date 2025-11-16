public var pixelPlayer:Bool = true;
public var pixelOpponent:Bool = true;

private var daPixelZoom:Float = PlayState.daPixelZoom;

function postCreate()
{
	if(!pixelPlayer) return;

	gameOverSong = 'pixel/gameOver';
	lossSFX = 'pixel/gameOverSFX';
	retrySFX = 'pixel/gameOverEnd';
}

function onCountdown(event)
{
	if(!pixelPlayer) return;

	if(event.soundPath != null) event.soundPath = 'pixel/' + event.soundPath;
	event.antialiasing = false;
	event.scale = daPixelZoom;
	event.spritePath = switch(event.swagCounter) {
		case 0: null;
		case 1: 'game/pixelUI/ready';
		case 2: 'game/pixelUI/set';
		case 3: 'game/pixelUI/go' + (PlayState.SONG.meta.name.toLowerCase() == 'your-demise' ? '-demise' : '');
	};
}

function onSongStart()
{
	if(!pixelPlayer) return;

	if(timeTxt != null) timeTxt.font = Paths.font('vcr.ttf');
}

function onStrumCreation(event)
{
	if((event.player == 1 && !pixelPlayer) || (event.player == 0 && !pixelOpponent)) return;
	event.cancel();

	var strum = event.strum;
	strum.loadGraphic(Paths.image('game/pixelUI/notes/default'), true, 17, 17);
	var maxCol = Math.floor(strum.graphic.width / 17);
	var strumID = event.strumID % maxCol;

	strum.animation.add('static', [strumID]);
	strum.animation.add('pressed', [maxCol + strumID, (maxCol * 2) + strumID], 12, false);
	strum.animation.add('confirm', [(maxCol * 3) + strumID, (maxCol * 4) + strumID], 12, false);

	var strumScale = strumLines.members[event.player].strumScale;
	strum.scale.set(daPixelZoom * strumScale, daPixelZoom * strumScale);
	strum.updateHitbox();
	strum.antialiasing = false;
}

function onNoteCreation(event)
{
	if((event.note.strumLine == playerStrums && !pixelPlayer) || (event.note.strumLine == cpuStrums && !pixelOpponent)) return;
	event.cancel();

	var note = event.note;
	var type = event.noteType;
	var strumID = event.strumID;

	type = switch(type)
	{
		case 'Alt Anim Note' | 'No Anim Note' | '' | null: 'default';
		case 'Markov No Anim Note': 'Markov Note';
		default: event.noteType;
	};

	if(event.note.isSustainNote)
	{
		note.loadGraphic(Paths.image('game/pixelUI/notes/' + type + 'ENDS'), true, 7, 6);
		var maxCol = Math.floor(note.graphic.width / 7);
		note.animation.add('hold', [strumID % maxCol]);
		note.animation.add('holdend', [maxCol + strumID % maxCol]);
	}
	else
	{
		note.loadGraphic(Paths.image('game/pixelUI/notes/' + type), true, 17, 17);
		var maxCol = Math.floor(note.graphic.width / 17);
		note.animation.add('scroll', [(type != 'default' ? 0 : maxCol) + strumID % maxCol]);
	}
	var strumScale = event.note.strumLine.strumScale;
	note.scale.set(daPixelZoom * strumScale, daPixelZoom * strumScale);
	note.updateHitbox();
	note.antialiasing = false;
}

function onPostNoteCreation(event)
{
	if(!pixelPlayer) return;

	if(event.note.splash == 'default') event.note.splash = 'pixel';
	else event.note.splash = event.note.splash + '-pixel';
}

function onPlayerHit(event)
{
	if(!pixelPlayer) return;

	event.ratingPrefix = 'game/pixelUI/score/';
	event.ratingScale = daPixelZoom * 0.7;
	event.ratingAntialiasing = false;

	event.numScale = daPixelZoom * 0.7;
	event.numAntialiasing = false;
}