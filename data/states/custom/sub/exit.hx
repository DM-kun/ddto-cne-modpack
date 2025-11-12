import flixel.effects.FlxFlicker;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;
import lime.system.System;

var allowInput:Bool = true;
var onYes:Bool = true;

var txtYes:FlxText;
var txtNo:FlxText;

function create()
{
	var bg:FlxSprite = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.WHITE);
	bg.antialiasing = false;
	bg.alpha = 0.5;
	add(bg);

	var box:FlxSprite = new FlxSprite(0, 0, Paths.image('menus/popup' + (FlxG.save.data.onBadEnding ? '-evil' : '')));
	box.antialiasing = false;
	box.screenCenter();
	add(box);

	var text:FlxText = new FlxText(0, box.y + 76, box.width * 0.95, "Are you sure you want to\nexit the game?", 32);
	text.setFormat(Paths.font('Aller_Rg.ttf'), 32, FlxColor.BLACK, FlxTextAlign.CENTER);
	text.antialiasing = Options.antialiasing;
	text.screenCenter(FlxAxes.X);
	add(text);

	txtYes = new FlxText(box.x + (box.width * 0.18), box.y + (box.height * 0.65), 0, "Yes", 48);
	txtYes.setFormat(Paths.font('riffic.ttf'), 48, FlxColor.WHITE, FlxTextAlign.CENTER);
	txtYes.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFFFF7CFF, 3);
	txtYes.antialiasing = Options.antialiasing;
	add(txtYes);

	txtNo = new FlxText(box.x + (box.width * 0.7), box.y + (box.height * 0.65), 0, "No", 48);
	txtNo.setFormat(Paths.font('riffic.ttf'), 48, FlxColor.WHITE, FlxTextAlign.CENTER);
	txtNo.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFFFF7CFF, 3);
	txtNo.antialiasing = Options.antialiasing;
	add(txtNo);

	changeItem();
}

function update()
{
	if(!allowInput) return;

	if(FlxG.mouse.overlaps(txtYes) && !onYes)
	{
		changeItem();
		CoolUtil.playMenuSFX(0, 0.7);
	}

	if(FlxG.mouse.overlaps(txtNo) && onYes)
	{
		changeItem();
		CoolUtil.playMenuSFX(0, 0.7);
	}

	if(controls.LEFT_P || controls.RIGHT_P) changeItem();

	if(controls.ACCEPT || FlxG.mouse.justPressed) confirmSelection();
	if(controls.BACK)
	{
		onYes = false;
		confirmSelection();
	}
}

function changeItem()
{
	onYes = !onYes;
	CoolUtil.playMenuSFX(0, 0.7);

	txtYes.setBorderStyle(FlxTextBorderStyle.OUTLINE, onYes ? 0xFFFFCFFF : 0xFFFF7CFF, 3);
	txtNo.setBorderStyle(FlxTextBorderStyle.OUTLINE, onYes ? 0xFFFF7CFF : 0xFFFFCFFF, 3);
}

function confirmSelection()
{
	allowInputs = false;
	CoolUtil.playMenuSFX(onYes ? 1 : 2, 0.7);

	if(!onYes) FlxFlicker.flicker(txtNo, 0.6, 0.06, false, false, (_) -> close());
	else FlxFlicker.flicker(txtYes, 1, 0.06, false, false, (_) -> System.exit(0));
}