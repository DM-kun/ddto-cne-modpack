public static var camOther:FlxCamera = null;
var lerpHealth:Float = 1;

function postCreate()
{
	camOther = new FlxCamera();
	camOther.bgColor = 0;
	FlxG.cameras.add(camOther, false);

	var playerColor:Int = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33);
	var opponentColor:Int = dad != null && dad.iconColor != null && Options.colorHealthBar ? dad.iconColor : (PlayState.opponentMode ? 0xFF66FF33 : 0xFFFF0000);

	var offset:FlxPoint = FlxPoint.get(3, 3);
	healthBar.setPosition(healthBarBG.x + offset.x, healthBarBG.y + offset.y);
	healthBar.barWidth = Std.int(healthBarBG.width - offset.x * 2);
	healthBar.barHeight = Std.int(healthBarBG.height - offset.y * 2);
	healthBar.createFilledBar(opponentColor, playerColor);
	healthBar.numDivisions = 1000;
	healthBar.updateBar();
}

function postUpdate(elapsed:Float)
{
	lerpHealth = lerp(lerpHealth, health, 0.15);
	healthBar.value = FlxMath.roundDecimal(lerpHealth, 3);
}

function destroy()
{
	if(camOther != null)
	{
		if(FlxG.cameras.list.contains(camOther))
			FlxG.cameras.remove(camOther);
		camOther.destroy();
	}
}