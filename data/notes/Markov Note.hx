function onNoteCreation(event)
{
	if(event.noteType != 'Markov Note') return;
	event.note.avoid = PlayState.opponentMode;
	event.note.splash = 'markov';
}

function onPlayerHit(event)
{
	if(event.noteType != 'Markov Note' || PlayState.opponentMode) return;
	event.cancel();
	health -= 100;
	gameOver();
}

function onPlayerMiss(event)
{
	if(event.noteType != 'Markov Note' || PlayState.opponentMode) return;
	event.cancel();
}