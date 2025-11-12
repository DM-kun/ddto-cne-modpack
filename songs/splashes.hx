var allowRotation:Bool = true;

function onSplashShown(event)
{
	switch(event.splashName.toLowerCase())
	{
		case 'libitina' | 'pixel': allowRotation = false;
		default: allowRotation = true;
	}

	if(StringTools.endsWith(event.splashName.toLowerCase(), '-pixel')) allowRotation = false;

	if(allowRotation)
		event.splash.angle = FlxG.random.float(0, 45);
}