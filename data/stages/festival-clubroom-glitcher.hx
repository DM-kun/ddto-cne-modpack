var bloomShader:CustomShader = new CustomShader('bloom');
var normalChars = [];
var pixelChars = [];
var isPixel:Bool = true;

function create()
{
	bloomShader.range = 0.1;
	bloomShader.steps = 0.005;
	bloomShader.threshhold = 0.8;
	bloomShader.brightness = 7.0;
}

function postCreate()
{
	camGame.addShader(bloomShader);

	for(strumLine in strumLines.members)
	{
		strumLine.characters[0].color = 0x828282;
		normalChars.push(strumLine.characters[0]);
		pixelChars.push(strumLine.characters[1]);
	}

	switchPixel('0');
}

function onPlayerHit(event)
{
	if(!isPixel) return;

	event.ratingPrefix = 'game/pixelUI/score/';
	event.ratingScale = PlayState.daPixelZoom * 0.7;
	event.ratingAntialiasing = false;

	event.numScale = PlayState.daPixelZoom * 0.7;
	event.numAntialiasing = false;
}

function onStrumCreation(event)
{
	if(event.player < 3) return;
	event.cancel();

	var strum = event.strum;
	strum.loadGraphic(Paths.image('game/pixelUI/notes/default'), true, 17, 17);
	var maxCol = Math.floor(strum.graphic.width / 17);
	var strumID = event.strumID % maxCol;

	strum.animation.add('static', [strumID]);
	strum.animation.add('pressed', [maxCol + strumID, (maxCol * 2) + strumID], 12, false);
	strum.animation.add('confirm', [(maxCol * 3) + strumID, (maxCol * 4) + strumID], 12, false);

	var strumScale = strumLines.members[event.player].strumScale;
	strum.scale.set(PlayState.daPixelZoom * strumScale, PlayState.daPixelZoom * strumScale);
	strum.updateHitbox();
	strum.antialiasing = false;
}

function onNoteCreation(event)
{
	if(event.strumLineID < 3) return;
	event.cancel();

	var note = event.note;
	var type = event.noteType;
	var strumID = event.strumID;

	type = switch(type)
	{
		case 'Alt Anim Note' | 'No Anim Note' | '' | null: 'default';
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
	note.scale.set(PlayState.daPixelZoom * strumScale, PlayState.daPixelZoom * strumScale);
	note.updateHitbox();
	note.antialiasing = false;
}

function onPostNoteCreation(event)
{
	if(event.strumLineID < 3) return;

	if(event.note.splash == 'default') event.note.splash = 'pixel';
	else event.note.splash = event.note.splash + '-pixel';
}

function switchPixel()
{
	isPixel = !isPixel;

	sky.visible = backTrees.visible = school.visible = street.visible = treesFG.visible = treesBG.visible = petals.visible = isPixel;
	closetFar.visible = clubroom.visible = lightsBG.visible = banner.visible = desksFG.visible = lightsFG.visible = dokis.visible = !isPixel;

	for(character in normalChars) character.visible = !isPixel;
	for(character in pixelChars) character.visible = isPixel;

	if(timeTxt != null) timeTxt.font = Paths.font(isPixel ? 'vcr.ttf' : 'Aller_Rg.ttf');

	bloomShader.threshhold = isPixel ? 1 : 0.8;
}

function destroy()
{
	camGame.removeShader(bloomShader);
}