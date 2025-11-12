import funkin.backend.utils.DiscordUtil;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.FlxFlicker;

private static var titleInit:Bool = false;
var allowInputs:Bool = true;
var danced:Bool = false;

var gf:FlxSprite;
var logo:FlxSprite;
var text:FlxSprite;

var curWacky:Array<String> = [];
var credGroup:FlxGroup;

var black:FlxSprite;
var hueh:FlxSprite;
var tbd:FlxSprite;

var dokiPos:Array<Float> = [0, 0];
var dokiChar:FlxSprite;
var dokiText:FlxSprite;

private var menuPath:String = 'menus/title/';

function create()
{
	DiscordUtil.changePresence('On the Title', null);

	if(FlxG.sound.music == null || !FlxG.sound.music.playing)
	{
		CoolUtil.playMusic(Paths.music('freakyMenu'), true, 0, true, 120);
		FlxG.sound.music.fadeIn(2, 0, 0.7);
	}

	var bg:FlxBackdrop = new FlxBackdrop(Paths.image('menus/bg'));
	bg.antialiasing = Options.antialiasing;
	bg.velocity.set(-10, 0);
	add(bg);

	var poc:FlxBackdrop = new FlxBackdrop(Paths.image('game/credits/pocBackground'));
	poc.antialiasing = Options.antialiasing;
	poc.velocity.set(-50, 0);
	add(poc);

	var scanlines:FlxBackdrop = new FlxBackdrop(Paths.image('game/credits/scanlines'), FlxAxes.Y);
	scanlines.antialiasing = Options.antialiasing;
	scanlines.scale.set(FlxG.width, 1);
	scanlines.updateHitbox();
	scanlines.screenCenter();
	scanlines.velocity.set(0, 20);
	add(scanlines);

	var gradient:FlxSprite = new FlxSprite(0, 0, Paths.image('game/gradient'));
	gradient.antialiasing = Options.antialiasing;
	gradient.setGraphicSize(FlxG.width, FlxG.height);
	gradient.updateHitbox();
	gradient.screenCenter();
	gradient.flipY = true;
	add(gradient);

	gf = new FunkinSprite(FlxG.width * 0.4, FlxG.height * 0.07);
	gf.frames = Paths.getSparrowAtlas(menuPath + 'gf');
	gf.animation.addByIndices('danceLeft', 'GF Dancing Beat', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
	gf.animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
	gf.animation.play('danceLeft');
	gf.antialiasing = Options.antialiasing;
	add(gf);

	logo = new FlxSprite(-40, -12);
	logo.frames = Paths.getSparrowAtlas(menuPath + 'logo');
	logo.animation.addByPrefix('bump', 'logo', 24, false);
	logo.animation.play('bump');
	logo.antialiasing = Options.antialiasing;
	logo.scale.set(0.8, 0.8);
	logo.updateHitbox();
	add(logo);

	text = new FlxSprite(170, FlxG.height * 0.8);
	text.frames = Paths.getSparrowAtlas(menuPath + 'text');
	text.animation.addByPrefix('idle', 'idle', 24, false);
	text.animation.addByPrefix('press', 'press', 24, false);
	text.animation.play('idle');
	text.antialiasing = Options.antialiasing;
	add(text);

	if(!titleInit)
	{
		curWacky = FlxG.random.getObject(getIntroTextShit());

		black = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(black);

		credGroup = new FlxGroup();
		add(credGroup);

		var huehArray:Array<String> = ['tbd', 'natsuki', 'sayori', 'yuri', 'monika', 'protag'];

		hueh = new FlxSprite(0, FlxG.height * 0.6, Paths.image(menuPath + 'hueh/' + huehArray[FlxG.random.int(0, huehArray.length-1)]));
		hueh.antialiasing = false;
		hueh.scale.set(1.6, 1.6);
		hueh.updateHitbox();
		hueh.screenCenter(FlxAxes.X);
		hueh.visible = false;
		add(hueh);

		tbd = new FlxSprite(0, FlxG.height * 0.45, Paths.image(menuPath + 'logo-tbd'));
		tbd.antialiasing = Options.antialiasing;
		tbd.scale.set(0.9, 0.9);
		tbd.updateHitbox();
		tbd.screenCenter(FlxAxes.X);
		tbd.visible = false;
		add(tbd);

		// [character, [bottom, top]]
		var dokiArray:Array<Array<Dynamic>> = [
			['natsuki', [770, 270]],
			['sayori', [770, 270]],
			['yuri', [770, 240]]
		];

		if(FlxG.save.data.weeksBeaten.contains('yuri'))
			dokiArray.push(['monika', [770, 180]]);

		if(FlxG.save.data.weeksBeaten.contains('protag'))
			dokiArray.push(['protag', [770, 180]]);

		var selected:Int = FlxG.random.int(0, dokiArray.length-1);
		dokiPos = dokiArray[selected][1];

		dokiChar = new FlxSprite(0, dokiPos[0]);
		dokiChar.frames = Paths.getSparrowAtlas(menuPath + 'intro/' + dokiArray[selected][0]);
		dokiChar.animation.addByPrefix('pop', dokiArray[selected][0], 24, false);
		dokiChar.animation.play('pop');
		dokiChar.antialiasing = Options.antialiasing;
		dokiChar.screenCenter(FlxAxes.X);
		add(dokiChar);

		dokiText = new FlxSprite(50, 100);
		dokiText.frames = Paths.getSparrowAtlas(menuPath + 'intro/text');
		dokiText.animation.addByPrefix('doki', 'doki', 24, false);
		dokiText.animation.play('doki');
		dokiText.antialiasing = Options.antialiasing;
		dokiText.visible = false;
		add(dokiText);
	}
}

function getIntroTextShit()
{
	var txtFile = Paths.txt('title/introText');
	var fullText:String = Assets.exists(txtFile) ? Assets.getText(txtFile) : 'placeholder--uh oh';

	var firstArray:Array<String> = fullText.split('\n');
	var swagGoodArray:Array<Array<String>> = [];

	for(i in firstArray)
	{
		swagGoodArray.push(i.split('--'));
	}

	return swagGoodArray;
}

function skipIntro()
{
	if(titleInit) return;

	titleInit = true;
	FlxG.camera.flash(FlxColor.WHITE, 4);

	black.destroy();
	remove(black);

	hueh.destroy();
	remove(hueh);

	tbd.destroy();
	remove(tbd);

	dokiText.destroy();
	remove(dokiText);

	FlxTween.cancelTweensOf(dokiChar);
	dokiChar.destroy();
	remove(dokiChar);

	while(credGroup.members.length > 0)
	{
		credGroup.members[0].destroy();
		credGroup.remove(credGroup.members[0], true);
	}
	credGroup.destroy();
	remove(credGroup);
}

function update(elapsed)
{
	if(!allowInputs) return;

	if(controls.ACCEPT)
	{
		if(titleInit) confirm();
		else skipIntro();
	}
}

function confirm()
{
	allowInputs = false;

	CoolUtil.playMenuSFX(1, 0.7);
	text.animation.play('press', true);
	FlxG.camera.flash(FlxColor.WHITE, 1, null, true);

	new FlxTimer().start(1.4, (_) -> FlxG.switchState(new MainMenuState()));
}

function createCoolText(textArray:Array<String>)
{
	for(i => txt in textArray)
	{
		if(txt == "" || txt == null) continue;

		var money:Alphabet = new Alphabet(0, (i * 60) + 200, txt, "bold");
		money.screenCenter(FlxAxes.X);
		credGroup.add(money);
	}
}

function addMoreText(txt:String)
{
	var coolText:Alphabet = new Alphabet(0, (credGroup.length * 60) + 200, txt, "bold");
	coolText.screenCenter(FlxAxes.X);
	credGroup.add(coolText);
}

function deleteCoolText()
{
	while(credGroup.members.length > 0)
	{
		credGroup.members[0].destroy();
		credGroup.remove(credGroup.members[0], true);
	}
}

function beatHit(curBeat)
{
	logo.animation.play('bump', true);

	if(danced) gf.animation.play('danceLeft', true);
	else gf.animation.play('danceRight', true);
	danced = !danced;

	if(titleInit) return;

	switch(curBeat)
	{
		case 1:
			createCoolText(['Team TBD']);
		case 2:
			tbd.visible = true;
		case 4:
			deleteCoolText();
			tbd.visible = false;
		case 5:
			createCoolText(['Ported', 'to']);
		case 6:
			addMoreText('Codename Engine');
			hueh.visible = true;
		case 8:
			deleteCoolText();
			hueh.visible = false;
		case 9:
			createCoolText([curWacky[0]]);
		case 10:
			addMoreText(curWacky[1]);
		case 12:
			deleteCoolText();
		case 13:
			dokiChar.animation.play('pop', true);
			FlxTween.tween(dokiChar, {y: dokiPos[1], "scale.x": 0.75}, 0.15, {
				ease: FlxEase.sineIn,
				startDelay: 0.2,
				onComplete: (_) -> FlxTween.tween(dokiChar, {"scale.x": 1}, 0.2, {ease: FlxEase.bounceInOut})
			});
		case 14:
			dokiText.visible = true;
			dokiText.animation.play('doki', true);
		case 16:
			skipIntro();
	}
}