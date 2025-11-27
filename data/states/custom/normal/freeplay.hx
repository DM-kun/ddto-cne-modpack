import funkin.backend.MusicBeatTransition;
import funkin.backend.chart.Chart;
import funkin.backend.chart.ChartData.ChartMetaData;
import funkin.backend.utils.DiscordUtil;
import funkin.backend.week.Week;
import funkin.menus.StoryMenuState.StoryWeeklist;
import flixel.effects.FlxFlicker;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;

private static var curPage:Int = 0;
private static var curSong:Int = 0;

var pages:Array<String> = [];
var songs:Array<Array<ChartMetaData>> = [];

var allowInputs:Bool = true;

var usingMouse:Bool = false;
var mouseNotMovedTime:Float = 0;

var grpPages:FlxTypedGroup<FlxSprite>;
var grpSongs:FlxTypedGroup<FlxText>;

private var menuPath:String = 'menus/freeplay/';

function create()
{
	DiscordUtil.changePresence('In the Freeplay Menu', null);

	CoolUtil.playMenuSong(false);

	getFreeplaySongs();

	grpPages = new FlxTypedGroup();
	add(grpPages);

	grpSongs = new FlxTypedGroup();
	add(grpSongs);

	for(num => page in pages)
	{
		var bg:FlxSprite = new FlxSprite(0, 0, Paths.image(menuPath + page));
		bg.antialiasing = Options.antialiasing;
		bg.screenCenter();
		bg.ID = num;
		grpPages.add(bg);

		for(i => song in songs[num])
		{
			var text:FlxText = new FlxText(442, 116 + (i * 47.5), 500, song.displayName, 29);
			text.setFormat(Paths.font("Halogen.otf"), 29, FlxColor.BLACK, FlxTextAlign.LEFT);
			text.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFFFF7CFF, 2);
			text.antialiasing = Options.antialiasing;
			text.ID = i;
			grpSongs.add(text);
		}
	}

	changePage(0, false);
}

function getFreeplaySongs()
{
	var list = Paths.txt('freeplay/list');
	if(!Assets.exists(list)) return trace('You fucked up.');

	pages = CoolUtil.coolTextFile(list);
	if(pages.length < 1) return trace('You fucked up AGAIN.');

	for(page in pages)
	{
		var pageList = Paths.txt('freeplay/' + page);
		if(!Assets.exists(pageList)) continue;

		var songList:Array<String> = CoolUtil.coolTextFile(pageList);
		if(songList.length < 1) continue;

		var songData:Array<ChartMetaData> = [];
		for(song in songList) songData.push(Chart.loadChartMeta(song, true));
		songs.push(songData);
	}
}

function update(elapsed)
{
	if(!allowInputs) return;

	if(usingMouse)
	{
		grpSongs.forEach(function(txt:FlxText) {
			if(!txt.visible) continue;
			if(FlxG.mouse.overlaps(txt))
			{
				if(curSong != txt.ID)
				{
					curSong = txt.ID;
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

	if(controls.RIGHT_P) changePage(1, true);
	if(controls.LEFT_P) changePage(-1, true);

	if(controls.DOWN_P || FlxG.mouse.wheel < 0) changeSelection(1, true);
	if(controls.UP_P || FlxG.mouse.wheel > 0) changeSelection(-1, true);

	if(controls.ACCEPT) confirmSelection();
	if(controls.BACK)
	{
		allowInputs = false;
		CoolUtil.playMenuSFX(2, 0.7);
		new FlxTimer().start(0.6, (_) -> FlxG.switchState(new MainMenuState()));
	}
}

function changePage(change:Int, playSound:Bool)
{
	if(playSound) CoolUtil.playMenuSFX(0, 0.7);
	curPage = FlxMath.wrap(curPage + change, 0, pages.length - 1);

	grpPages.forEach(function(spr:FlxSprite) {
		spr.visible = (spr.ID == curPage);
	});

	changeSelection(0, false);
}

function changeSelection(change:Int, playSound:Bool)
{
	if(playSound) CoolUtil.playMenuSFX(0, 0.7);
	curSong = FlxMath.wrap(curSong + change, 0, songs[curPage].length - 1);

	grpSongs.forEach(function(txt:FlxText) {
		txt.setBorderStyle(FlxTextBorderStyle.OUTLINE, (txt.ID == curSong) ? 0xFFFFCFFF : 0xFFFF7CFF, 2);
	});
}

function confirmSelection()
{
	allowInputs = false;
	CoolUtil.playMenuSFX(1, 0.7);

	PlayState.loadSong(songs[curPage][curSong].name, 'normal');
	FlxFlicker.flicker(grpSongs.members[curSong], 1, 0.06, false, false, (_) -> FlxG.switchState(new PlayState()));
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

function onOpenSubState(event)
{
	if(event.substate is MusicBeatTransition) return;

	persistentDraw = true;
	persistentUpdate = false;
}