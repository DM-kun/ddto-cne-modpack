import funkin.backend.system.Flags;
import funkin.backend.utils.WindowUtils;

var tmpBlack:FlxSprite;

function postCreate()
{
	introSounds = ['intro3-glitch', 'intro2-glitch', 'intro1-glitch', 'introGo-glitch'];
	add(tmpBlack = new FlxSprite(-1000, -1000).makeSolid(FlxG.width*3, FlxG.height*3, FlxColor.BLACK));
}

function onCountdown(event)
{
	WindowUtils.setWindow("Friday Night Funkin': Just Monika!", Flags.MOD_ICON);
}

function onSongStart()
{
	FlxTween.tween(tmpBlack, {alpha: 0}, 0.8, {
		ease: FlxEase.sineOut,
		onComplete: function(_) {
			remove(tmpBlack);
			tmpBlack.destroy();
		}
	});
}