import funkin.backend.MusicBeatTransition;
import funkin.backend.utils.DiscordUtil;
import funkin.editors.EditorPicker;
import funkin.menus.ModSwitchMenu;
import funkin.menus.WarningState;
import funkin.menus.credits.CreditsMain;
import funkin.options.OptionsMenu;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.FlxFlicker;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;
import Xml;

private static var mainInit:Bool = false;
private static var curSelected:Int = 0;

var allowInputs:Bool = false;

var usingMouse:Bool = false;
var mouseNotMovedTime:Float = 0;

var grpMenuItems:FlxTypedGroup<FlxText>;
var menuItems:Array<Array<Dynamic>> = [
	['Story Mode', true],
	['Freeplay', FlxG.save.data.weeksBeaten.contains('prologue')],
	['Gallery', FlxG.save.data.weeksBeaten.contains('side-story')],
	['Credits', FlxG.save.data.weeksBeaten.contains('protag')],
	['Options', true],
	['Exit Game', true]
];
var realItems:Array<String> = [];

var character:FunkinSprite;
var logo:FlxSprite;
var shaker:FlxSprite;

private var menuPath:String = 'menus/main/';

function create()
{
	DiscordUtil.changePresence('In the Main Menu', null);

	CoolUtil.playMenuSong(false);

	FlxG.mouse.visible = true;

	var bg:FlxBackdrop = new FlxBackdrop(Paths.image('menus/bg'));
	bg.antialiasing = Options.antialiasing;
	bg.velocity.set(-40, -40);
	add(bg);

	createMenuChar();

	var side:FlxSprite = new FlxSprite(mainInit ? -60 : -260, 0, Paths.image('menus/side'));
	side.antialiasing = Options.antialiasing;
	add(side);

	logo = new FlxSprite(mainInit ? 40 : -160, -40);
	logo.frames = Paths.getSparrowAtlas('menus/logo');
	logo.animation.addByPrefix('bump', 'logo', 24, false);
	logo.animation.play('bump');
	logo.antialiasing = Options.antialiasing;
	logo.scale.set(0.5, 0.5);
	logo.updateHitbox();
	add(logo);

	grpMenuItems = new FlxTypedGroup();
	add(grpMenuItems);

	for(fin => option in menuItems)
	{
		if(!option[1]) continue;

		var item:FlxText = new FlxText(mainInit ? 50 : -350, 370 + (realItems.length * 50), 0, option[0]);
		item.setFormat(Paths.font('riffic.ttf'), 27, FlxColor.WHITE, FlxTextAlign.LEFT);
		item.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFFFF7CFF, 2);
		item.antialiasing = Options.antialiasing;
		item.ID = realItems.length;
		grpMenuItems.add(item);

		realItems.push(option[0].toLowerCase());

		if(mainInit) continue;

		FlxTween.tween(item, {x: 50}, 1.2, {
			ease: FlxEase.elasticOut,
			startDelay: 0.2 * (realItems.length - 1),
			onComplete: function(_) {
				if(fin == menuItems.length - 1)
				{
					mainInit = allowInputs = true;
					changeSelection(0, true);
				}
			}
		});
	}

	if(FlxG.save.data.weeksBeaten.contains('side-story') && !FlxG.save.data.songsBeaten.contains('va11halla'))
	{
		shaker = new FlxSprite(1132, 538);
		shaker.frames = Paths.getSparrowAtlas(menuPath + 'shaker');
		shaker.animation.addByPrefix('shaker', 'shaker', 21, false);
		shaker.animation.play('shaker');
		shaker.antialiasing = false;
		add(shaker);
	}

	var version:FlxText = new FlxText(mainInit ? 5 : -350, FlxG.height - 24, 0, 'v' + Flags.VERSION, 16);
	version.setFormat(Paths.font('aller.ttf'), 16, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	version.antialiasing = Options.antialiasing;
	add(version);

	if(mainInit)
	{
		allowInputs = true;
		changeSelection(0, false);
	}
	else
	{
		FlxTween.tween(side, {x: -60}, 1.2, {ease: FlxEase.elasticOut});
		FlxTween.tween(logo, {x: 40}, 1.2, {ease: FlxEase.elasticOut});
		FlxTween.tween(version, {x: 5}, 1.2, {ease: FlxEase.elasticOut});
	}
}

function createMenuChar()
{
	var high:Array<String> = ['together-alt', 'yuri', 'natsuki', 'sayori', 'monika-pixel', 'senpai'];
	var mid:Array<String> = ['sunnat', 'yuritabi', 'minusmonikapixel', 'yuriken', 'sayominus', 'cyrixstatic', 'zipori', 'nathaachama', 'sayomongus'];
	var low:Array<String> = ['fumo'];

	if(FlxG.save.data.weeksBeaten.contains('festival')) high.push('protag');
	if(FlxG.save.data.weeksBeaten.contains('monika'))
	{
		high.remove('together-alt');
		high.remove('monika-pixel');
		high.push('together');
		high.push('monika');

		mid.push('deeppoems');
		mid.push('akimonika');
		mid.push('indiehorror');
	}
	if(FlxG.save.data.costumesUnlocked.contains('antipathy')) mid.push('nathank');

	// TO-DO: re-do this because somehow fumo isn't rare at ALL
	var random:Float = FlxG.random.floatNormal(0, 1);
	var chance:Array<String> = random >= 0.98 ? low : ((random >= 0.60 && random < 0.98) ? mid : high);

	var charName:String = chance[FlxG.random.int(0, chance.length-1)];
	if(!Assets.exists(Paths.xml('characters/menu/' + charName))) charName = 'together-alt';

	var char:Xml = Xml.parse(Assets.getText(Paths.xml('characters/menu/' + charName))).firstElement();
	if(char.get('name') == null) char.set('name', charName);
	if(char.get('sprite') == null) char.set('sprite', charName);
	if(char.get('updateHitbox') == null) char.set('updateHitbox', 'true');

	var offsetX:Float = char.get('x') != null ? Std.parseFloat(char.get('x')) : 0;
	var offsetY:Float = char.get('y') != null ? Std.parseFloat(char.get('y')) : 0;

	character = XMLUtil.createSpriteFromXML(char, menuPath + 'characters/');
	character.offset.set(offsetX, offsetY);
	character.updateHitbox();
	// character.antialiasing = Options.antialiasing;
	add(character);
}

function update(elapsed)
{
	if(!allowInputs) return;

	if(usingMouse)
	{
		grpMenuItems.forEach(function(txt:FlxText) {
			if(FlxG.mouse.overlaps(txt))
			{
				if(curSelected != txt.ID)
				{
					curSelected = txt.ID;
					changeSelection(0, true);
				}
				if(FlxG.mouse.justPressed) confirmSelection();
			}
		});

		if(FlxG.mouse.justPressed)
		{
			if(FlxG.save.data.weeksBeaten.contains('yuri') && FlxG.mouse.overlaps(logo))
				switchEnding();

			if(shaker != null && FlxG.mouse.overlaps(shaker))
				startSong();
		}

		mouseNotMovedTime += elapsed;
		if(mouseNotMovedTime > 1.6)
		{
			usingMouse = false;
			FlxG.mouse.visible = false;
		}

		if(usedMouse()) mouseNotMovedTime = 0;
	}
	else if(usedMouse()) usingMouse = true;

	if(controls.SWITCHMOD) openSubState(new ModSwitchMenu());
	if(controls.DEV_ACCESS) openSubState(new EditorPicker());

	if(controls.DOWN_P || controls.UP_P || FlxG.mouse.wheel != 0)
	{
		usingMouse = false;
		FlxG.mouse.visible = false;
	}

	if(controls.DOWN_P || FlxG.mouse.wheel < 0) changeSelection(1, true);
	if(controls.UP_P || FlxG.mouse.wheel > 0) changeSelection(-1, true);

	if(controls.ACCEPT) confirmSelection();
	if(controls.BACK)
	{
		allowInputs = false;
		CoolUtil.playMenuSFX(2, 0.7);
		new FlxTimer().start(0.6, (_) -> FlxG.switchState(new TitleState()));
	}
}

function beatHit(curBeat)
{
	if(character != null && curBeat % 2 == 0)
		character.beatHit(curBeat);

	logo.animation.play('bump', true);

	if(shaker != null) shaker.animation.play('shaker', true);
}

function changeSelection(change:Int, playSound:Bool)
{
	if(playSound) CoolUtil.playMenuSFX(0, 0.7);
	curSelected = FlxMath.wrap(curSelected + change, 0, realItems.length - 1);

	grpMenuItems.forEach(function(txt:FlxText) {
		txt.setBorderStyle(FlxTextBorderStyle.OUTLINE, (txt.ID == curSelected) ? 0xFFFFCFFF : 0xFFFF7CFF, 2);
	});
}

function confirmSelection()
{
	allowInputs = false;

	CoolUtil.playMenuSFX(1, 0.7);
	lastState = MainMenuState;

	FlxFlicker.flicker(grpMenuItems.members[curSelected], 1, 0.06, true, false, (_) -> switch(realItems[curSelected].toLowerCase()) {
		case 'story mode': FlxG.switchState(new StoryMenuState());
		case 'freeplay': FlxG.switchState(new FreeplayState());
		case 'options': FlxG.switchState(new OptionsMenu());
		case 'credits': FlxG.switchState(new CreditsMain());
		case 'exit game':
			openSubState(new ModSubState('custom/sub/exit'));
			allowInputs = true;
		// case 'gallery': FlxG.switchState(new ModState('custom/gallery'));
		default: allowInputs = true;
	});
}

function usedMouse():Bool
{
	if((FlxG.mouse.deltaScreenX != 0 && FlxG.mouse.deltaScreenY != 0) || FlxG.mouse.justPressed)
	{
		FlxG.mouse.visible = true;
		mouseNotMovedTime = 0;
		return true;
	}
	return false;
}

function startSong()
{
	allowInputs = false;

	FlxG.sound.play(Paths.sound('va11hallaSelect'));
	FlxFlicker.flicker(shaker, 1, 0.06, false, false);

	PlayState.loadSong('drinks-on-me', 'normal');
	new FlxTimer().start(1, (_) -> FlxG.switchState(new PlayState()));
}

function switchEnding()
{
	allowInputs = false;

	CoolUtil.playMenuSFX(1, 0.7);
	FlxG.sound.music.fadeOut(0.75, 0, (_) -> FlxG.sound.music.stop());

	FlxG.save.data.onBadEnding = true;
	FlxG.camera.fade(FlxColor.BLACK, 1, false, () -> FlxG.switchState(new WarningState()));
}

function onOpenSubState(event)
{
	if(event.substate is MusicBeatTransition) return;

	persistentDraw = true;
	persistentUpdate = false;
}