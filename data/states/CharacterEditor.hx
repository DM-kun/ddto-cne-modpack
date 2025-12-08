var useScript:Bool = true;

var curStage:String = "stage";

var backChar:Character;

function create()
{
	if(useScript) return;
	disableScript();
}

function postCreate()
{
	backChar = new Character(0, 0, 'bf-doki', character.isPlayer);
	backChar.debugMode = true;
	reloadPositions();
}

function update()
{
	if(curStage != currentStage)
		reloadPositions();
}

function reloadPositions()
{
	curStage = currentStage;

	remove(backChar);
	if(stage.characterPoses.exists(stagePosition))
		stage.applyCharStuff(backChar, stagePosition, 0);
	backChar.cameras = [charCamera];
	backChar.alpha = 0.25;
	remove(backChar);
	insert(members.indexOf(character), backChar);
}