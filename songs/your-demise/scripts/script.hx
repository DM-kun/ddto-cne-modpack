import funkin.backend.system.Flags;
import funkin.backend.utils.WindowUtils;

function postCreate()
{
	introSounds = ['intro3-glitch', 'intro2-glitch', 'intro1-glitch', 'introGo-glitch'];
}

function onCountdown(event)
{
	WindowUtils.setWindow("Friday Night Funkin': Just Monika!", Flags.MOD_ICON);
}

function onPostCountdown(event)
{
	if(event.sprite == null) return;
	event.sprite.cameras = [camHUD];
}