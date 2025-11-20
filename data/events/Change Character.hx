function postCreate()
{
	// removed null-check on the strum character array - it can NEVER be null unless the player set it themselves -> that's their issue
	for(strumLine in strumLines.members)
	{
		for(i => character in strumLine.characters)
		{
			if(character == null) continue;
			character.visible = (i == 0); // make only the very first char visible
		}
	}
}

function onEvent(event)
{
	if(event.event.name.toLowerCase() != 'change character') return;

	var newChar = null; // we'll use this to save the char data (so we dont need to keep using the strum stuff...)
	var strumID:Int = event.event.params[0];
	var charID:Int = event.event.params[1];
	for(i => character in strumLines.members[strumID].characters) // once again, removed null-check for array
	{
		if(character == null) continue;
		character.visible = (i == charID); // Makes only the new character visible
		if(i == charID) newChar = character;
	}

	if(strumID > 1 || newChar == null) return; // no need to update icon and healthbar if it's not a main strum

	var opponent = null;
	for(i => character in strumLines.members[0].characters)
	{
		if(character == null || !character.visible) continue;
		opponent = character;
	}

	var player = null;
	for(i => character in strumLines.members[1].characters)
	{
		if(character == null || !character.visible) continue;
		player = character;
	}

	var icon:HealthIcon = newChar.isPlayer ? iconP1 : iconP2;
	if(icon != null) icon.setIcon(newChar.getIcon());

	var leftColor:Int = opponent != null && opponent.iconColor != null && Options.colorHealthBar ? opponent.iconColor : (opponentMode ? 0xFF66FF33 : 0xFFFF0000);
	var rightColor:Int = player != null && player.iconColor != null && Options.colorHealthBar ? player.iconColor : (opponentMode ? 0xFFFF0000 : 0xFF66FF33);
	healthBar.createFilledBar(leftColor, rightColor);
	healthBar.updateBar();

	if(timeBar != null)
	{
		timeBar.createGradientBar([FlxColor.TRANSPARENT], [rightColor, leftColor]);
		timeBar.updateBar();
	}
}