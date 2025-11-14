function create()
{
	if(cutscene == null || cutscene.length < 1)
	{
		var cutscenePath = Paths.script('data/scripts/cutscene');
		if(Assets.exists(cutscenePath)) cutscene = cutscenePath;
	}

	if(endCutscene == null || endCutscene.length < 1)
	{
		var endCutscenePath = Paths.script('data/scripts/cutscene-end');
		if(Assets.exists(endCutscenePath)) endCutscene = endCutscenePath;
	}
}