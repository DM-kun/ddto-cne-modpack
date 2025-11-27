function postCreate()
{
	PlayState.instance.curCameraTarget = 0;
	PlayState.instance.moveCamera();
	PlayState.instance.camGame.scroll.set(PlayState.instance.camFollow.x, PlayState.instance.camFollow.y);
}