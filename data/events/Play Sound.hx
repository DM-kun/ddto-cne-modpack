function onEvent(event)
{
	if(event.event.name.toLowerCase() != 'play sound') return;

	var sound:String = event.event.params[0];
	if(sound == null || sound == "" || !Assets.exists(Paths.sound(sound))) return;

	FlxG.sound.play(Paths.sound(event.event.params[0]), event.event.params[1]);
}