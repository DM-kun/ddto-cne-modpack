import funkin.game.cutscenes.DialogueCutscene;

var didFade:Bool = false;

function next(event)
{
	if(didFade) return;
	canProceed = false;

	var blackScreen:FlxSprite = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
	blackScreen.antialiasing = false;
	add(blackScreen);

	FlxTween.tween(blackScreen, {alpha: 0}, 3, {
		onComplete: function(twn:FlxTween) {
			remove(blackScreen);
			blackScreen.destroy();
			didFade = canProceed = true;
			DialogueCutscene.cutscene.next(true);
		}
	});
}