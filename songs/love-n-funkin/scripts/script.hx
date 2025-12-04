var curSinger:String = 'monika';

function onSongStart()
{
	for(num => strumLine in strumLines.members)
	{
		if(num < 2) continue;
		for(strum in strumLine.members)
		{
			strum.visible = false;
		}
	}
}

function onPlayerHit(event)
{
	if(!PlayState.opponentMode) return;

	strumLines.members[0].members[event.note.strumID].press(event.note.strumTime);
	updateBars(event.character);
}

function onDadHit(event)
{
	if(PlayState.opponentMode) return;

	strumLines.members[0].members[event.note.strumID].press(event.note.strumTime);
	updateBars(event.character);
}

function updateBars(character)
{
	if(curSinger == character.curCharacter) return;
	curSinger = character.curCharacter;

	iconP2.setIcon(character.getIcon());

	var oppChar = character;
	var playerColor:Int = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33);
	var opponentColor:Int = oppChar != null && oppChar.iconColor != null && Options.colorHealthBar ? oppChar.iconColor : (PlayState.opponentMode ? 0xFF66FF33 : 0xFFFF0000);
	healthBar.createFilledBar(opponentColor, playerColor);
	healthBar.updateBar();

	if(timeBar != null)
	{
		timeBar.createGradientBar([FlxColor.TRANSPARENT], [playerColor, opponentColor]);
		timeBar.updateBar();
	}
}