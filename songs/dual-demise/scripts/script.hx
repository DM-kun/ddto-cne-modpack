var curSinger:String = 'monika-big-pixel';

function postCreate()
{
	introSounds = ['intro3-glitch', 'intro2-glitch', 'intro1-glitch', 'introGo-glitch'];
}

function onSongStart()
{
	for(strum in strumLines.members[2].members)
		strum.visible = false;
}

function onPlayerHit(event)
{
	if(!PlayState.opponentMode) return;

	strumLines.members[0].members[event.note.strumID].press(event.note.strumTime);

	if(curSinger == event.character.curCharacter) return;

	curSinger = event.character.curCharacter;
	updateBars(event.character);
}

function onDadHit(event)
{
	if(PlayState.opponentMode) return;

	strumLines.members[0].members[event.note.strumID].press(event.note.strumTime);

	if(curSinger == event.character.curCharacter) return;

	curSinger = event.character.curCharacter;
	updateBars(event.character);
}

function updateBars(character)
{
	iconP2.setIcon(character.getIcon());

	var oppChar = character;
	var playerColor:Int = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : (opponentMode ? 0xFFFF0000 : 0xFF66FF33);
	var opponentColor:Int = oppChar != null && oppChar.iconColor != null && Options.colorHealthBar ? oppChar.iconColor : (opponentMode ? 0xFF66FF33 : 0xFFFF0000);
	healthBar.createFilledBar(opponentColor, playerColor);
	healthBar.updateBar();

	if(timeBar != null)
	{
		timeBar.createGradientBar([FlxColor.TRANSPARENT], [playerColor, opponentColor]);
		timeBar.updateBar();
	}

	curSinger = character.curCharacter;
}