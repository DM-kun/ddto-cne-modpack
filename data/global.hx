import funkin.backend.system.Flags;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.utils.WindowUtils;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

// to fix the window icon flickering
public static var switchingMod:Bool = false;

// to fix going back to playstate from the options
public static var lastState:FlxState = null;

// functions
function preStateSwitch()
{
	if(switchingMod)
	{
		switchingMod = false;
		WindowUtils.setWindow(Flags.TITLE, 'window/iconOG');
	}

	Mouse.cursor = MouseCursor.ARROW;
	FlxG.mouse.useSystemCursor = true;
	FlxG.mouse.visible = false;

	Framerate.offset.set(0, 0);
}

function postStateSwitch() //post is more consistent than pre
{
	// window title + icon
	WindowUtils.setWindow(Flags.TITLE, Flags.MOD_ICON);

	// reset mouse cursor
	Mouse.cursor = MouseCursor.ARROW;

	// make sure no shaders remain
	FlxG.game.setFilters([]);

	// smaller Framerate counter
	Framerate.codenameBuildField.visible = false;

	// bgColor
	FlxG.camera.bgColor = 0xFF000000;
}

function destroy()
{
	FlxG.camera.bgColor = 0xFF000000;

	WindowUtils.setWindow(Flags.TITLE, 'window/iconOG');
	WindowUtils.resetAffixes();
	WindowUtils.resetTitle();

	FlxG.game.setFilters([]);

	Framerate.offset.set(0, 0);
	Framerate.codenameBuildField.visible = true;
}

// save shit
// progress
FlxG.save.data.songsBeaten ??= [];
FlxG.save.data.weeksBeaten ??= [];
FlxG.save.data.costumesUnlocked ??= [];

// misc stuff
FlxG.save.data.onBadEnding ??= false;
FlxG.save.data.seenWarning ??= false;
FlxG.save.data.seenWarningEvil ??= false;
