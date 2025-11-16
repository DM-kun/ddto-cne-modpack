function onNoteCreation(event)
{
	if(event.noteType != 'Markov Note' && event.noteType != 'Markov No Anim Note') return;
	event.noteSprite = 'game/notes/Markov Note';
	event.note.avoid = PlayState.opponentMode;
	event.note.splash = 'markov';
}

function onPlayerHit(event)
{
	if((event.noteType != 'Markov Note' && event.noteType != 'Markov No Anim Note') || PlayState.opponentMode) return;
	event.cancel();
	health -= 100;
	gameOver();
}

function onDadHit(event)
{
	if(event.noteType != 'Markov No Anim Note') return;
	event.preventAnim();
}

function onPlayerMiss(event)
{
	if((event.noteType != 'Markov Note' && event.noteType != 'Markov No Anim Note') || PlayState.opponentMode) return;
	event.cancel();
}