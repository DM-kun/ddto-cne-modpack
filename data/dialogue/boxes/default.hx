var bgFade:FlxSprite;
var finished:Bool = false;

function postCreate()
{
	bgFade = new FlxSprite().makeSolid(FlxG.width + 100, FlxG.height + 100, 0xFFCEF4FF);
	bgFade.antialiasing = false;
	bgFade.screenCenter();
	bgFade.scrollFactor.set();
	bgFade.alpha = 0;
	cutscene.insert(0, bgFade);

	FlxTween.tween(bgFade, {alpha: 0.4}, 0.8);
}

function close(event)
{
	if(finished) return;
	event.cancelled = true;
	cutscene.canProceed = false;

	cutscene.curMusic?.fadeOut(1, 0);
	for(c in cutscene.charMap) c.visible = false;
	FlxTween.tween(cutscene.dialogueBox, {alpha: 0, "text.alpha": 0}, 1);

	FlxTween.cancelTweensOf(bgFade);
	FlxTween.tween(bgFade, {alpha: 0}, 0.8, {onComplete: function(_) {
		finished = true;
		cutscene.close();
	}});
}