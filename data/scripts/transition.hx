function create(event)
{
	event.cancel();

	transitionSprite = new FunkinSprite().makeSolid(FlxG.width + 100, FlxG.height + 100, FlxColor.BLACK);
	transitionSprite.antialiasing = false;
	transitionSprite.screenCenter();
	transitionSprite.scrollFactor.set();
	transitionSprite.alpha = newState != null ? 0 : 1;
	add(transitionSprite);

	transitionTween = FlxTween.tween(transitionSprite, {alpha: newState != null ? 1 : 0}, 0.6, {
		ease: newState != null ? FlxEase.sineOut : FlxEase.sineIn,
		onComplete: (_) -> finish()
	});
}