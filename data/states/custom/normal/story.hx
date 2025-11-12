import funkin.backend.MusicBeatTransition;
import funkin.backend.utils.DiscordUtil;
import funkin.backend.week.Week;
import funkin.menus.StoryMenuState.StoryWeeklist;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.FlxFlicker;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;

private static var curWeek:Int = 0;
var weeks = StoryWeeklist.get(true, false).weeks;
var hasSideStory:Bool = FlxG.save.data.weeksBeaten.contains('protag');

var allowInputs:Bool = true;

var usingMouse:Bool = false;
var mouseNotMovedTime:Float = 0;

var grpMenuItems:FlxTypedGroup<FunkinSprite>;
var sideStory:FunkinSprite;

var logo:FlxSprite;
var list:FlxSprite;
var tracks:FlxText;
var cursor:FlxSprite;
var title:FlxText;

private var menuPath:String = 'menus/story/';

function create()
{
	DiscordUtil.changePresence('In the Story Menu', null);

	CoolUtil.playMenuSong(false);

	FlxG.mouse.visible = true;

	var bg:FlxBackdrop = new FlxBackdrop(Paths.image('menus/bg'));
	bg.antialiasing = Options.antialiasing;
	bg.velocity.set(-40, -40);
	add(bg);

	grpMenuItems = new FlxTypedGroup();
	add(grpMenuItems);

	cursor = new FlxSprite(0, 0, Paths.image(menuPath + 'cursor'));
	cursor.antialiasing = Options.antialiasing;
	cursor.updateHitbox();
	add(cursor);

	title = new FlxText(394, 150, 870, "???", 38);
	title.setFormat(Paths.font('riffic.ttf'), 38, FlxColor.WHITE, FlxTextAlign.CENTER);
	title.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFFF860B0, 2, 1);
	title.antialiasing = Options.globalAntialiasing;
	add(title);

	var side:FlxSprite = new FlxSprite(-60, 0, Paths.image('menus/side'));
	side.antialiasing = Options.antialiasing;
	add(side);

	list = new FlxSprite(50, 360, Paths.image(menuPath + 'list'));
	list.antialiasing = Options.antialiasing;
	add(list);

	tracks = new FlxText(0, list.y + 80, 330, "", 25);
	tracks.setFormat(Paths.font('riffic.ttf'), 25, FlxColor.WHITE, FlxTextAlign.CENTER);
	tracks.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFFFFB9DD, 3, 1);
	tracks.antialiasing = Options.antialiasing;
	add(tracks);

	logo = new FlxSprite(40, -40);
	logo.frames = Paths.getSparrowAtlas('menus/logo');
	logo.animation.addByPrefix('bump', 'logo', 24, false);
	logo.animation.play('bump');
	logo.antialiasing = Options.antialiasing;
	logo.scale.set(0.5, 0.5);
	logo.updateHitbox();
	add(logo);

	for(num => week in weeks)
	{
		if(num == weeks.length - 1) break;

		var portrait:String = (FlxG.save.data.weeksBeaten.contains(week.sprite.toLowerCase()) || num == 0) ? week.id : 'locked';
		var data = Week.loadWeekCharacter(portrait);
		var char:FunkinSprite = XMLUtil.createSpriteFromXML(data.xml, menuPath + 'portraits/');
		char.setPosition((218 * (num % 4)) + 394, (170 * Math.floor(num / 4)) + 199);
		char.antialiasing = Options.antialiasing;
		char.ID = num;
		grpMenuItems.add(char);
		if(portrait == 'locked') char.beatHit(0);
	}

	if(hasSideStory)
	{
		var data = Week.loadWeekCharacter(weeks[weeks.length-1].id);
		sideStory = XMLUtil.createSpriteFromXML(data.xml, menuPath + 'portraits/');
		sideStory.setPosition(394, (170 * 3) + 199);
		sideStory.antialiasing = Options.antialiasing;
		sideStory.ID = weeks.length - 1;
		add(sideStory);
	}

	changeSelection(0, false);
}

function update(elapsed)
{
	if(!allowInputs) return;

	if(usingMouse)
	{
		grpMenuItems.forEach(function(spr:FunkinSprite) {
			if(FlxG.mouse.overlaps(spr))
			{
				if(curWeek != spr.ID)
				{
					curWeek = spr.ID;
					changeSelection(0, true);
				}
				if(FlxG.mouse.justPressed) confirmSelection();
			}
		});

		mouseNotMovedTime += elapsed;
		if(mouseNotMovedTime > 1.6)
		{
			usingMouse = false;
			FlxG.mouse.visible = false;
		}

		if(usedMouse()) mouseNotMovedTime = 0;
	}
	else if(usedMouse()) usingMouse = true;

	if(controls.LEFT_P || controls.DOWN_P || controls.UP_P || controls.RIGHT_P || FlxG.mouse.wheel != 0)
	{
		usingMouse = false;
		FlxG.mouse.visible = false;
	}

	if(controls.RIGHT_P) changeSelection(1, true);
	if(controls.LEFT_P) changeSelection(-1, true);

	if(controls.DOWN_P || FlxG.mouse.wheel < 0) changeSelection(4, true);
	if(controls.UP_P || FlxG.mouse.wheel > 0) changeSelection(-4, true);

	if(controls.ACCEPT) confirmSelection();
	if(controls.BACK)
	{
		allowInputs = false;
		CoolUtil.playMenuSFX(2, 0.7);
		new FlxTimer().start(0.6, (_) -> FlxG.switchState(new MainMenuState()));
	}
}

function beatHit(curBeat)
{
	grpMenuItems.forEachAlive(function(spr:FunkinSprite) {
		if(spr.ID == curWeek) spr.beatHit(curBeat);
	});

	if(hasSideStory && spr.ID == curWeek) sideStory.beatHit(curBeat);

	logo.animation.play('bump', true);
}

function changeSelection(change:Int, playSound:Bool)
{
	if(playSound) CoolUtil.playMenuSFX(0, 0.7);
	curWeek = FlxMath.wrap(curWeek + change, 0, weeks.length - (hasSideStory ? 1 : 2));

	cursor.visible = (weeks[curWeek].id != 'side-stories');
	title.visible = (weeks[curWeek].id != 'side-stories');
	list.visible = (weeks[curWeek].id != 'side-stories');
	tracks.visible = (weeks[curWeek].id != 'side-stories');

	FlxTween.cancelTweensOf(cursor);
	FlxTween.tween(cursor, {x: grpMenuItems.members[curWeek].x, y: grpMenuItems.members[curWeek].y}, 0.1, {ease: FlxEase.quadOut});

	title.text = weekUnlocked() ? weeks[curWeek].name : '???';

	var temp:String = "";
	for(song in weeks[curWeek].songs)
	{
		if(song.hide && !FlxG.save.data.songsBeaten.contains(song.name.toLowerCase())) continue;
		temp += song.displayName + '\n';
	}
	tracks.text = weekUnlocked() ? temp : '???';
}

function confirmSelection()
{
	if(!weekUnlocked())
	{
		CoolUtil.playMenuSFX(2, 0.7);
		return;
	}

	allowInputs = false;
	CoolUtil.playMenuSFX(1, 0.7);

	PlayState.loadWeek(weeks[curWeek], 'normal');
	FlxFlicker.flicker(grpMenuItems.members[curWeek], 1, 0.06, false, false, (_) -> FlxG.switchState(new PlayState()));
	cursor.visible = false;
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

function weekUnlocked():Bool
{
	return (FlxG.save.data.weeksBeaten.contains(weeks[curWeek].sprite.toLowerCase()) || curWeek == 0);
}

function onOpenSubState(event)
{
	if(event.substate is MusicBeatTransition) return;

	persistentDraw = true;
	persistentUpdate = false;
}