var allowInputs:Bool = false;
var switchState:Bool = false;

private var menuPath:String = 'menus/warning/';

function create()
{
	var bg:FlxSprite = new FlxSprite(0, 0, Paths.image(menuPath + 'bg' + (FlxG.save.data.onBadEnding ? '-evil' : '')));
	bg.antialiasing = Options.antialiasing;
	bg.screenCenter();
	add(bg);

	FlxG.camera.fade(FlxColor.BLACK, 1, true, () -> allowInputs = true);

	if((!FlxG.save.data.onBadEnding && FlxG.save.data.seenWarning) || (FlxG.save.data.onBadEnding && FlxG.save.data.seenWarningEvil))
		switchState = true;
}

function update()
{
	if(switchState) FlxG.switchState(FlxG.save.data.onBadEnding ? new ModState('custom/evil/title') : new TitleState());

	if(!allowInputs) return;

	if(controls.ACCEPT) confirm();
}

function confirm()
{
	allowInputs = false;
	CoolUtil.playMenuSFX(1, 0.7);
	FlxG.camera.fade(FlxColor.BLACK, 1, false, () -> FlxG.switchState(FlxG.save.data.onBadEnding ? new ModState('custom/evil/title') : new TitleState()));
}