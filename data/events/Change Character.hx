function postCreate()
{
	for(strumLine in strumLines.members)
	{
		for(i => character in strumLine.characters)
		{
			if(character == null) continue;
			character.visible = (i == 0);
		}
	}

	for(event in events)
	{
		if(event.name != 'Change Character' || event.time > 10) continue;
		onEvent({event: event});
		events.remove(event);
	}
}

var needsUpdate:Bool = false;
function onSongStart()
{
	if(timeBar == null || !needsUpdate) return;

	timeBar.createGradientBar([FlxColor.TRANSPARENT], [rightColor, leftColor]);
	timeBar.updateBar();
}

function onEvent(event)
{
	if(event.event.name.toLowerCase() != 'change character') return;

	var strumID:Int = event.event.params[0];
	var charID:Int = event.event.params[1];

	if(charID > strumLines.members[strumID].characters.length - 1) return;

	var newChar = null;
	for(i => character in strumLines.members[strumID].characters)
	{
		if(character == null) continue;
		character.visible = (i == charID);
		if(i == charID) newChar = character;
	}

	if(strumID > 1 || newChar == null) return;

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

	var leftColor:Int = opponent != null && opponent.iconColor != null && Options.colorHealthBar ? opponent.iconColor : (PlayState.opponentMode ? 0xFF66FF33 : 0xFFFF0000);
	var rightColor:Int = player != null && player.iconColor != null && Options.colorHealthBar ? player.iconColor : (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33);
	healthBar.createFilledBar(leftColor, rightColor);
	healthBar.updateBar();

	if(timeBar != null)
	{
		timeBar.createGradientBar([FlxColor.TRANSPARENT], [rightColor, leftColor]);
		timeBar.updateBar();
	}
	else needsUpdate = true;
}