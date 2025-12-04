// using this over v-slice sustains due to some character anims in this mod
function onPostNoteHit(e)
{
	if(e.animCancelled) return;

	var paused:Bool = (e.note.nextNote != null && e.note.nextNote.isSustainNote);

	for(character in e.characters)
	{
		if(character == null) continue;

		if(character.animateAtlas == null) character.animation.curAnim.paused = paused;
		else character.animateAtlas.anim.isPlaying = paused;
	}

	e.note.strumLine.members[e.note.strumID].animation.curAnim.paused = paused;
}