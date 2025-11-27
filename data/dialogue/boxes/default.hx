var bgImage:FlxSprite;

function postCreate()
{
	bgImage = new FlxSprite().makeSolid(FlxG.width + 100, FlxG.height + 100, 0xFFB3DFD8);
	bgImage.antialiasing = false;
	bgImage.screenCenter();
	bgImage.scrollFactor.set();
	bgImage.alpha = 0;
	cutscene.insert(0, bgImage);
}

var first:Bool = false;
function playBubbleAnim()
{
	if(first) return;
	first = true;
	FlxTween.tween(bgImage, {alpha: 0.4}, 0.8);
}

var finished:Bool = false;
function close(event)
{
	if(finished) return;
	event.cancelled = true;
	cutscene.canProceed = false;

	cutscene.curMusic?.fadeOut(1, 0);
	for(c in cutscene.charMap) c.visible = false;
	FlxTween.tween(cutscene.dialogueBox, {alpha: 0, "text.alpha": 0}, 1);

	FlxTween.cancelTweensOf(bgImage);
	FlxTween.tween(bgImage, {alpha: 0}, 0.8, {onComplete: function(_) {
		finished = true;
		cutscene.close();
	}});
}