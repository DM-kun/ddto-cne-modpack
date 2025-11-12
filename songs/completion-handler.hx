// TO-DO: make a better check for beating a week
function onSongEnd()
{
	var songName:String = PlayState.SONG.meta.name.toLowerCase();
	if(!FlxG.save.data.songsBeaten.contains(songName))
		FlxG.save.data.songsBeaten.push(songName);

	if(PlayState.isStoryMode && PlayState.storyPlaylist.length <= 1) // can't check for 0 - onSongEnd is called BEFORE the song is removed
	{
		var weekName:String = PlayState.storyWeek.id.toLowerCase();
		if(!FlxG.save.data.weeksBeaten.contains(weekName))
			FlxG.save.data.weeksBeaten.push(weekName);
	}
}