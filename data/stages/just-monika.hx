import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.addons.display.FlxBackdrop;
import openfl.display.BlendMode;
import FramerateTools;

public var camGame2:FlxCamera;
var bloomShader:CustomShader = new CustomShader('bloom');

var forever:Bool = false;

var space:FlxBackdrop;
var clouds:FlxBackdrop;
var mask:FlxBackdrop;
var scroll:FlxBackdrop;

var popup:FlxSprite;

function create()
{
	bloomShader.range = 0.1;
	bloomShader.steps = 0.005;
	bloomShader.threshhold = 0.95;
	bloomShader.brightness = 8.0;

	camGame2 = new FlxCamera().copyFrom(FlxG.camera);
	camGame2.bgColor = 0;
	FlxG.cameras.insert(camGame2, 1, false);
	camGame2.follow(camFollow, FlxCameraFollowStyle.LOCKON, Flags.DEFAULT_CAMERA_FOLLOW_SPEED);
	camGame2.focusOn(camFollow.getPosition());
}

function postCreate()
{
	camGame.addShader(bloomShader);

	for(strumLine in strumLines.members)
	{
		for(character in strumLine.characters)
		{
			if(character == null) continue;
			character.cameras = [camGame2];
		}
	}
	table.cameras = [camGame2];
	lights.cameras = [camGame2];
	lights.blend = BlendMode.SCREEN;

	space = new FlxBackdrop(Paths.image('stages/clubroom-evil/sky'));
	space.antialiasing = Options.antialiasing;
	space.scrollFactor.set(0.1, 0.1);
	space.velocity.set(-7, 0);
	space.scale.set(0.7, 0.7);
	space.updateHitbox();
	insert(0, space);

	clouds = new FlxBackdrop(Paths.image('stages/clubroom-evil/clouds'));
	clouds.antialiasing = Options.antialiasing;
	clouds.scrollFactor.set(0.1, 0.1);
	clouds.velocity.set(-13, 0);
	clouds.scale.set(0.7, 0.7);
	clouds.updateHitbox();
	insert(1, clouds);

	mask = new FlxBackdrop(Paths.image('stages/clubroom-evil/mask'));
	mask.antialiasing = Options.antialiasing;
	mask.scrollFactor.set(0.1, 0.1);
	mask.velocity.set(-13, 0);
	mask.scale.set(0.7, 0.7);
	mask.updateHitbox();
	insert(2, mask);

	scroll = new FlxBackdrop(Paths.image('menus/bg'));
	scroll.antialiasing = Options.antialiasing;
	scroll.velocity.set(-40, -40);
	scroll.cameras = [camGame2];
	scroll.alpha = 0;
	insert(members.indexOf(table), scroll);

	popup = new FlxSprite(350, 400);
	popup.frames = Paths.getSparrowAtlas('stages/clubroom-evil/monika-delete');
	popup.animation.addByPrefix('idle', 'PopUpAnim', 24, false);
	popup.animation.play('idle');
	popup.antialiasing = Options.antialiasing;
	popup.cameras = [camGame2];
	popup.visible = false;
	insert(members.indexOf(dad) + 1, popup);
}

var floatShit:Float = 0;
var floatShit2:Float = 0.1;
function update()
{
	camGame2.zoomMultiplier = FlxG.camera.zoomMultiplier;
	camGame2.zoom = FlxG.camera.zoom;
	camGame2.followEnabled = FlxG.camera.followEnabled;
	camGame2.followLerp = FlxG.camera.followLerp;

	floatShit += 0.007 / FramerateTools.timeMultiplier();
	floatShit2 += 0.007 / FramerateTools.timeMultiplier();
	mask.alpha += Math.sin(floatShit) / FramerateTools.timeMultiplier() / 5;
	windowlight.alpha += Math.sin(floatShit2) / FramerateTools.timeMultiplier() / 5;
	lights.alpha += Math.sin(floatShit2) / FramerateTools.timeMultiplier() / 5;
}

function onGameOver()
{
	camGame.removeShader(bloomShader);
}

function together()
{
	forever = !forever;

	FlxTween.cancelTweensOf(scroll);
	FlxTween.tween(scroll, {alpha: forever ? 1 : 0}, (Conductor.stepCrochet / 1000) * 8, {ease: forever ? FlxEase.sineIn : FlxEase.sineOut});
}

function verifyFiles()
{
	popup.visible = true;
	popup.animation.play('idle', true);
}

function deleteMonika()
{
	dad.playAnim((FlxG.save.data.songsBeaten.contains('epiphany') ? 'end-alt' : 'end'), true, 'LOCK');
	dad.animation.onFinish.add(function(anim:String) {
		for(strum in strumLines.members[0].members)
		{
			FlxTween.tween(strum, {alpha: 0}, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.sineOut});
		}
		FlxTween.tween(iconP2, {alpha: 0}, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.sineOut});

		var rightColor:Int = bf != null && bf.iconColor != null && Options.colorHealthBar ? bf.iconColor : (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33);
		healthBar.createFilledBar(FlxColor.BLACK, rightColor);
		healthBar.updateBar();

		if(timeBar != null)
		{
			timeBar.createGradientBar([FlxColor.TRANSPARENT], [rightColor, FlxColor.BLACK]);
			timeBar.updateBar();
		}
	});

	startedCountdown = false;
	canDie = false;
	canDadDie = false;
}

function destroy()
{
	camGame.removeShader(bloomShader);
}