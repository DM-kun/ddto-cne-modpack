import funkin.game.cutscenes.DialogueCutscene;

function onSubstateOpen(event)
{
	if(!(event.substate is DialogueCutscene)) return;
	PlayState.instance.camHUD.visible = false;
}

function onSubstateClose(event)
{
	if(!(event.substate is DialogueCutscene)) return;
	PlayState.instance.camHUD.visible = true;
}