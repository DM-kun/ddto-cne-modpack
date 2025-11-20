function onNoteCreation(event)
{
	if(event.noteType != 'Pixel Note') return;
	event.cancel();

	var note = event.note;
	var strumID = event.strumID;

	if(event.note.isSustainNote)
	{
		note.loadGraphic(Paths.image('game/pixelUI/notes/defaultENDS'), true, 7, 6);
		var maxCol = Math.floor(note.graphic.width / 7);
		note.animation.add('hold', [strumID % maxCol]);
		note.animation.add('holdend', [maxCol + strumID % maxCol]);
	}
	else
	{
		note.loadGraphic(Paths.image('game/pixelUI/notes/default'), true, 17, 17);
		var maxCol = Math.floor(note.graphic.width / 17);
		note.animation.add('scroll', [maxCol + strumID % maxCol]);
	}
	var strumScale = event.note.strumLine.strumScale;
	note.scale.set(PlayState.daPixelZoom * strumScale, PlayState.daPixelZoom * strumScale);
	note.updateHitbox();
	note.antialiasing = false;
}

function onPostNoteCreation(event)
{
	if(event.noteType != 'Pixel Note') return;

	event.note.splash = 'pixel';
}

function onPlayerHit(event)
{
	if(event.noteType != 'Pixel Note') return;

	event.ratingPrefix = 'game/pixelUI/score/';
	event.ratingScale = PlayState.daPixelZoom * 0.7;
	event.ratingAntialiasing = false;

	event.numScale = PlayState.daPixelZoom * 0.7;
	event.numAntialiasing = false;
}