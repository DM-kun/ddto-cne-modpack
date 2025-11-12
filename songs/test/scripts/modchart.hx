function postUpdate(elapsed)
{
	for(s in strumLines)
	{
		for(i in 0...4)
		{
			var n = s.members[i];
			n.angle = Math.sin(curBeatFloat + (i * 0.45)) * 35;
		}
	}
}