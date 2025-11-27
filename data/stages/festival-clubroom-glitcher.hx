import funkin.backend.system.Flags;

var bloomShader:CustomShader = new CustomShader('bloom');
var normalChars = [];
var pixelChars = [];
var isPixel:Bool = true;

private var daPixelZoom:Float = PlayState.daPixelZoom;

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

	for(i => strumLine in strumLines.members)
	{
		strumLine.characters[0].color = 0xFF828282;
		normalChars.push(strumLine.characters[0]);
		pixelChars.push(strumLine.characters[1]);
	}

	switchPixel();
}

function onPostCountdown(event)
{
	if(event.sprite == null) return;
	event.sprite.color = isPixel ? 0xFFFFFFFF : 0xFFC9C9C9;
}

function onPlayerHit(event)
{
	if(!isPixel) return;

	event.ratingPrefix = 'game/pixelUI/score/';
	event.ratingScale = daPixelZoom * 0.7;
	event.ratingAntialiasing = false;

	event.numScale = daPixelZoom * 0.7;
	event.numAntialiasing = false;
}

function onPostNoteHit()
{
	comboGroup.forEachAlive(function(spr) {
		spr.color = isPixel ? 0xFFFFFFFF : 0xFFC9C9C9;
	});
}

function switchPixel()
{
	isPixel = !isPixel;

	for(obj in [sky, backTrees, school, street, treesFG, treesBG, petals]) obj.visible = isPixel;
	for(obj in [closetFar, clubroom, lightsBG, banner, desksFG, lightsFG, dokis]) obj.visible = !isPixel;

	for(character in normalChars) character.visible = !isPixel;
	for(character in pixelChars) character.visible = isPixel;

	var newPlayer = isPixel ? pixelChars[1] : normalChars[1];
	var newOpponent = isPixel ? pixelChars[0] : normalChars[0];
	iconP1.setIcon(newPlayer.getIcon());
	iconP2.setIcon(newOpponent.getIcon());

	var leftColor:Int = newOpponent != null && newOpponent.iconColor != null && Options.colorHealthBar ? newOpponent.iconColor : (opponentMode ? 0xFF66FF33 : 0xFFFF0000);
	var rightColor:Int = newPlayer != null && newPlayer.iconColor != null && Options.colorHealthBar ? newPlayer.iconColor : (opponentMode ? 0xFFFF0000 : 0xFF66FF33);
	healthBar.createFilledBar(leftColor, rightColor);
	healthBar.updateBar();

	if(timeBar != null)
	{
		timeBar.createGradientBar([FlxColor.TRANSPARENT], [rightColor, leftColor]);
		timeBar.updateBar();
	}

	if(timeTxt != null) timeTxt.font = Paths.font(isPixel ? 'vcr.ttf' : 'Aller_Rg.ttf');

	bloomShader.threshhold = isPixel ? 1 : 0.8;

	gameOverSong = isPixel ? 'gameOver/pixel' : Flags.DEFAULT_GAMEOVER_MUSIC;
	lossSFX = isPixel ? 'gameOver/start-pixel' : Flags.DEFAULT_GAMEOVERSFX_SOUND;
	retrySFX = isPixel ? 'gameOver/end-pixel' : Flags.DEFAULT_GAMEOVEREND_SOUND;
}

function destroy()
{
	camGame.removeShader(bloomShader);
}