var cutscene:FlxSprite;
var bgImage:FlxSprite;
var extra:FlxSprite;

function postCreate()
{
	cutscene = new FlxSprite();
	cutscene.frames = Paths.getSparrowAtlas('dialogue/cutscenes/pixelEnding');
	cutscene.animation.addByPrefix('idle', 'cutscene', 24, false);
	cutscene.animation.play('idle');
	cutscene.antialiasing = false;
	cutscene.setGraphicSize(FlxG.width);
	cutscene.updateHitbox();
	cutscene.screenCenter();
	cutscene.visible = false;
	add(cutscene);

	bgImage = new FlxSprite(0, 0, Paths.image('dialogue/backgrounds/ending3'));
	bgImage.antialiasing = false;
	bgImage.setGraphicSize(FlxG.width);
	bgImage.updateHitbox();
	bgImage.screenCenter();
	bgImage.visible = false;
	insert(0, bgImage);

	extra = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.WHITE);
	extra.antialiasing = false;
	extra.screenCenter();
	extra.alpha = 0;
	add(extra);
}

function playCutscene()
{
	canProceed = false;

	extra.alpha = 1;
	FlxTween.tween(extra, {alpha: 0}, 0.5);
	cutscene.animation.play('idle', true);
	cutscene.visible = true;

	new FlxTimer().start(5, function(_) {
		extra.color = FlxColor.BLACK;
		FlxTween.tween(extra, {alpha: 1}, 4, {onComplete: function(_) {
			bgImage.visible = true;
			cutscene.visible = false;
			FlxTween.tween(extra, {alpha: 0}, 4, {onComplete: function(_) {
				canProceed = true;
				next(true);
			}});
		}});
	});
}