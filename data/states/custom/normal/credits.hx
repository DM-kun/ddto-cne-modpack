import funkin.backend.utils.DiscordUtil;
import Xml;

var allowInputs:Bool = true;

// Name[0] - Icon[1] - Description[2] - Role[3] - URL[4]
var teamData:Array<Array<String>> = [];
var roles:Array<String> = ['Mod Directors / Leads', 'Artists', 'Guest Artists', 'Programmers', 'Charters', 'Musicians', 'Music', 'Writing / Translation', 'Voices', 'Cameos', 'Additional Credits'];

private var menuPath:String = 'menus/credits/';

function create()
{
	if(!parseCreditsXML()) return;

	DiscordUtil.changePresence('In the Credis Menu', null);

	var bg:FlxSprite = new FlxSprite(0, 0, Paths.image(menuPath + 'bg'));
	bg.antialiasing = Options.antialiasing;
	add(bg);
}

function parseCreditsXML():Bool
{
	var data:Xml = Xml.parse(Assets.getText(Paths.xml('config/credits'))).firstElement();
	if(data == null) return false;

	for(node in data.elements())
	{
		var name:String = node.get('name') != null ? node.get('name') : 'Unknown';
		var icon:String = node.get('icon') != null ? node.get('icon') : 'face';
		var desc:String = node.get('desc') != null ? node.get('desc') : 'Missing Data';
		var role:String = node.get('role') != null ? node.get('role') : '10';
		var url:String = node.get('url') != null ? node.get('url') : '';
		teamData.push([name, icon, desc, role, url]);
	}
	return true;
}

function update(elapsed)
{
	if(!allowInputs) return;

	if(controls.ACCEPT) confirm();
}

function confirm()
{
	allowInputs = false;

	CoolUtil.playMenuSFX(1, 0.7);
}