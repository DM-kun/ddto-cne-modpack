function postShow(event)
{
	if(curTween == null) return;
	curTween.percent = 1;

	alpha = 0;
	switch(positionName)
	{
		case 'left': setPosition(event.x - 50, event.y);
		case 'right': setPosition(event.x + 50, event.y);
		default: setPosition(event.x, event.y + 50);
	}
	curTween = FlxTween.tween(this, {alpha: 1, x: event.x, y: event.y}, 0.4, {ease: FlxEase.quintOut});
}

function postHide()
{
	if(curTween == null) return;
	curTween.percent = 1;
}