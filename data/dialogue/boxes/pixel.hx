var loopedTimer:FlxTimer;
var bgFade:FlxSprite;
var finished:Bool = false;
var curAnim:String = "";

function postCreate()
{
	bgFade = new FlxSprite().makeSolid(FlxG.width + 100, FlxG.height + 100, 0xFFB3DFD8);
	bgFade.screenCenter();
	bgFade.scrollFactor.set();
	bgFade.alpha = 0;
	cutscene.insert(0, bgFade);

	loopedTimer = new FlxTimer().start(0.83, function(tmr:FlxTimer)
	{
		bgFade.alpha += (1 / 5) * 0.7;
		if(bgFade.alpha > 0.7)
			bgFade.alpha = 0.7;
	}, 5);
}

function playBubbleAnim(event)
{
	curAnim = event.bubble != null ? event.bubble : '';
	switch(curAnim)
	{
		case 'monika':
			cutscene.dialogueBox.text.color = 0xFF79375D;
			cutscene.dialogueBox.text.borderColor = 0xFFFFDFEE;
		case 'evil':
			cutscene.dialogueBox.text.color = FlxColor.WHITE;
			cutscene.dialogueBox.text.borderColor = 0xFF424242;
		default:
			cutscene.dialogueBox.text.color = 0xFF3F2021;
			cutscene.dialogueBox.text.borderColor = 0xFFD89494;
	}
}

function postStartText()
{
	cutscene.dialogueBox.text.completeCallback = function() {
		dialogueEnded = true;
		if(cutscene.dialogueBox.hasAnimation(curAnim + '-end'))
		{
			cutscene.dialogueBox.playAnim(curAnim + '-end');
		}
		else if(cutscene.dialogueBox.hasAnimation(curAnim + '-wait'))
			cutscene.dialogueBox.playAnim(curAnim + '-end');
	};
}

function close(event)
{
	if(finished) return;
	event.cancelled = true;

	cutscene.canProceed = false;

	cutscene.curMusic?.fadeOut(1, 0);
	for(c in cutscene.charMap) c.visible = false;

	loopedTimer.cancel();
	loopedTimer = new FlxTimer().start(0.2, function(tmr:FlxTimer)
	{
		if(tmr.elapsedLoops <= 5)
		{
			cutscene.dialogueBox.alpha -= 1 / 5;
			cutscene.dialogueBox.text.alpha -= 1 / 5;
			bgFade.alpha -= (1 / 5) * 0.7;
		}
		else
		{
			finished = true;
			cutscene.close();
		}
	}, 6);
}