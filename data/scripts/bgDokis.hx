import Xml;

public var dokis:FlxTypedGroup<FunkinSprite>;

function create()
{
	dokis = new FlxTypedGroup();
	insert(members.indexOf(stage.getSprite('tmp')), dokis);

	for(num => doki in ['sayori', 'protag', 'monika', 'yuri', 'natsuki'])
	{
		var data:Xml = Xml.parse(Assets.getText(Paths.xml('characters/bg/' + doki))).firstElement();
		if(data.get('name') == null) data.set('name', doki);
		if(data.get('sprite') == null) data.set('sprite', doki);
		if(data.get('updateHitbox') == null) data.set('updateHitbox', 'true');

		var character:FunkinSprite = XMLUtil.createSpriteFromXML(data, 'game/bgdoki/');
		character.name = doki;
		character.ID = num;
		dokis.add(character);

		if(StringTools.startsWith(curStage, 'festival')) character.color = 0x828282;
	}
}

function postCreate()
{
	for(strumLine in strumLines.members)
	{
		for(character in strumLine.characters)
		{
			if(character == null || !character.visible) continue;
			dokis.forEachAlive(function(spr:FunkinSprite) {
				spr.visible = !StringTools.startsWith(character.curCharacter, spr.name);
			});
		}
	}

	switch(strumLines.members[0].characters[0].curCharacter.toLowerCase())
	{
		case 'sayori':
			dokis.members[0].visible = false;
			dokis.members[1].setPosition(379, 152); // protag
			dokis.members[2].setPosition(1207, 173); // monika
			dokis.members[3].setPosition(-74, 176); // yuri
			dokis.members[4].setPosition(1044, 290); // natsuki

		case 'protag': // dokis don't wanna hang out with protag-kun    :(
			dokis.forEachAlive(function(spr:FunkinSprite) {
				spr.visible = false;
			});

		case 'natsuki':
			dokis.members[4].visible = false;
			dokis.members[0].setPosition(-49, 247); // sayori
			dokis.members[1].setPosition(379, 152); // protag
			dokis.members[2].setPosition(1207, 173); // monika
			dokis.members[3].setPosition(1044, 178); // yuri

		case 'yuri' | 'yuri-crazy':
			dokis.members[3].visible = false;
			dokis.members[0].setPosition(-49, 247); // sayori
			dokis.members[1].setPosition(379, 152); // protag
			dokis.members[2].setPosition(1207, 173); // monika
			dokis.members[4].setPosition(1044, 290); // natsuki

		case 'monika':
			dokis.members[2].visible = false;
			dokis.members[0].setPosition(-49, 247); // sayori
			dokis.members[1].setPosition(150, 152); // protag
			dokis.members[3].setPosition(1044, 178); // yuri
			dokis.members[4].setPosition(1247, 303); // natsuki
	}
}

function beatHit(curBeat)
{
	dokis.forEachAlive(function(spr:FunkinSprite) {
		spr.beatHit(curBeat);
	});
}