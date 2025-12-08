function onEvent(event)
{
	if(event.event.name.toLowerCase() != 'camera fade') return;

	var camera:FlxCamera = (event.event.params[3].toLowerCase() == 'camhud') ? camHUD : camGame;
	if(camera == camGame && camGame2 != null)
	{
		camera = camGame2;
		camGame.stopFade();
	}

	camera.stopFade();
	camera.fade(event.event.params[1], (Conductor.stepCrochet / 1000) * event.event.params[2], event.event.params[0]);
}

var crashDeath:Bool = false;
function onPlayerHit(event)
{
	if(event.noteType != 'Markov Note' && event.noteType != 'Markov No Anim Note') return;
	crashDeath = FlxG.random.bool(0.05);
}

function onGameOver(event)
{
	event.x = dad.x;
	event.y = dad.y;
	event.deathCharID = dad.gameOverCharacter;
	event.isPlayer = false;
	event.lossSFX = 'gameOver/start-monika' + (crashDeath ? '-crash' : '');
}