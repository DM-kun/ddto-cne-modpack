import openfl.display.BlendMode;

function postCreate()
{
	light.blend = BlendMode.ADD;

	if(PlayState.SONG.meta.name.toLowerCase() == 'shrinking-violet' && PlayState.variation == 'spooky')
	{
		board.loadGraphic(Paths.image('stages/musicroom/board-spooky'));
	}

	if(PlayState.SONG.meta.name.toLowerCase() == 'love-n-funkin')
	{
		board.loadGraphic(Paths.image('stages/musicroom/board-lnf'));

		// var poemSprite:String = (PlayState.variation != null ? PlayState.variation : '') + 'handoatlas';
		// poemVideo = new FlxAnimate(0, 0, Paths.getPath('images/stages/musicroom/notepad/' + poemSprite));
		// poemVideo.showPivot = false;
		// poemVideo.anim.addBySymbol('video', 'lnf video');
		// poemVideo.anim.play('video');
		// poemVideo.scrollFactor.set();
		// poemVideo.setGraphicSize(FlxG.width);
		// poemVideo.updateHitbox();
		// poemVideo.screenCenter();
		// poemVideo.antialiasing = Options.antialiasing;
		// poemVideo.visible = false;
		// add(poemVideo);
	}
}

// function poemTime()
// {
// 	poemVideo.visible = true;
// 	poemVideo.anim.play('video');
// }