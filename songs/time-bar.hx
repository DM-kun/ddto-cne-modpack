import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;
import flixel.ui.FlxBar;
import flixel.ui.FlxBar.FlxBarFillDirection;
import flixel.util.FlxStringUtil;

public var timeBarBG:FlxSprite;
public var timeBar:FlxBar;
public var timeTxt:FlxText;

public var displayName:String = '';
public var songLength:Float = 0;

function postCreate()
{
	displayName = PlayState.SONG.meta.displayName;
	songLength = inst.length / 1000;

	timeBarBG = new FlxSprite(0, 18);
	CoolUtil.loadAnimatedGraphic(timeBarBG, Paths.image('game/timeBar'));
	timeBarBG.antialiasing = Options.antialiasing;
	timeBarBG.updateHitbox();
	timeBarBG.cameras = [camHUD];
	timeBarBG.scrollFactor.set();
	timeBarBG.screenCenter(FlxAxes.X);
	timeBarBG.alpha = 0;
	insert(members.indexOf(healthBar) + 1, timeBarBG);

	var playerColor:Int = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33);
	var opponentColor:Int = dad != null && dad.iconColor != null && Options.colorHealthBar ? dad.iconColor : (PlayState.opponentMode ? 0xFF66FF33 : 0xFFFF0000);

	var offset:FlxPoint = FlxPoint.get(3, 3);
	timeBar = new FlxBar(timeBarBG.x + offset.x, timeBarBG.y + offset.y, FlxBarFillDirection.LEFT_TO_RIGHT, Std.int(timeBarBG.width - offset.x * 2), Std.int(timeBarBG.height - offset.y * 2), null, null, 0, songLength);
	timeBar.createGradientBar([FlxColor.TRANSPARENT], [playerColor, opponentColor]);
	timeBar.antialiasing = Options.antialiasing;
	timeBar.scrollFactor.set();
	timeBar.cameras = [camHUD];
	timeBar.numDivisions = 800;
	timeBar.alpha = 0;
	insert(members.indexOf(timeBarBG) + 1, timeBar);

	var fullText:String = displayName + ' (0:00 / ' + FlxStringUtil.formatTime(songLength) + ')';
	timeTxt = new FlxText(0, timeBarBG.y, 400, fullText, 18);
	timeTxt.setFormat(Paths.font('Aller_Rg.ttf'), 18, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	timeTxt.antialiasing = Options.antialiasing;
	timeTxt.scrollFactor.set();
	timeTxt.cameras = [camHUD];
	timeTxt.screenCenter(FlxAxes.X);
	timeTxt.alpha = 0;
	insert(members.indexOf(timeBar) + 1, timeTxt);
}

function onSongStart()
{
	tweenTimeBar(1, 0.5);
}

function postUpdate()
{
	timeBar.value = FlxMath.roundDecimal(FlxMath.bound(Conductor.songPosition / 1000, 0, songLength), 3);
	timeTxt.text = displayName + ' - ' + FlxStringUtil.formatTime(Conductor.songPosition / 1000) + ' / ' + FlxStringUtil.formatTime(songLength) + '';
}

public function tweenTimeBar(to:Float, duration:Float)
{
	for(obj in [timeBarBG, timeBar, timeTxt])
	{
		FlxTween.tween(obj, {alpha: to}, duration, {ease: FlxEase.circOut});
	}
}