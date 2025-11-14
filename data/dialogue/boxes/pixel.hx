var angryBounce:FlxTween;
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

	loopedTimer = new FlxTimer().start(0.4, function(tmr:FlxTimer)
	{
		bgFade.alpha += (1 / 5) * 0.7;
		if(bgFade.alpha > 0.7)
			bgFade.alpha = 0.7;
	}, 5);
}

function playBubbleAnim(event)
{
	if(angryBounce != null) angryBounce.cancel();

	if(curAnim != event.bubble && event.suffix == '' && cutscene.dialogueBox.hasAnimation(event.bubble + '-firstOpen'))
		event.suffix = '-firstOpen';

	switch(curAnim = event.bubble)
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

	if(event.bubble == 'week6-angry' && event.suffix == '-firstOpen')
	{
		var defaultScale:FlxPoint = FlxPoint.get(cutscene.dialogueBox.scale.x, cutscene.dialogueBox.scale.y);
		cutscene.dialogueBox.scale.set(defaultScale.x - 0.4, defaultScale.y - 0.4);
		angryBounce = FlxTween.tween(cutscene.dialogueBox.scale, {x: defaultScale.x, y: defaultScale.y}, 0.4, {ease: FlxEase.bounceOut});
	}
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