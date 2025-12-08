var glow:FlxSprite;
var ring:FlxSprite;
var one:FlxSprite;

function postCreate()
{
	var funnyX:Float = dad.x - dad.width / 4;
	var funnyY:Float = dad.y + dad.height / 6;

	glow = new FlxSprite(funnyX, funnyY, Paths.image('game/oneMore/glow'));
	glow.antialiasing = Options.antialiasing;
	glow.scale.set(2, 2);
	glow.updateHitbox();
	glow.alpha = 0;
	add(glow);

	ring = new FlxSprite(funnyX, funnyY, Paths.image('game/oneMore/ring'));
	ring.antialiasing = Options.antialiasing;
	ring.scale.set(2, 2);
	ring.updateHitbox();
	ring.alpha = 0;
	add(ring);

	one = new FlxSprite(funnyX, funnyY, Paths.image('game/oneMore/one'));
	one.antialiasing = Options.antialiasing;
	one.scale.set(2, 2);
	one.updateHitbox();
	one.alpha = 0;
	add(one);
}

function oneMore()
{
	ring.alpha = 1;
	FlxTween.tween(glow, {'scale.x': 2.2, 'scale.y': 2.2, alpha: 0.7}, 0.25, {
		ease: FlxEase.circOut,
		onComplete: function(_) {
			FlxTween.tween(glow, {'scale.x': 3, 'scale.y': 3, alpha: 0}, 0.25, {
				ease: FlxEase.circOut,
				onComplete: function(_) {
					remove(glow);
					glow.destroy();
				}
			});
		}
	});
	FlxTween.tween(ring, {'scale.x': 4, 'scale.y': 4, alpha: 0}, 0.5, {
		ease: FlxEase.circOut,
		onComplete: function(_) {
			remove(ring);
			ring.destroy();
		}
	});
	FlxTween.tween(one, {'scale.x': 2.2, 'scale.y': 2.2, alpha: 1}, 0.5, {
		ease: FlxEase.circOut,
		onComplete: function(_) {
			FlxTween.tween(one, {'scale.x': 3, 'scale.y': 3, alpha: 0}, 0.25, {
				ease: FlxEase.circOut,
				onComplete: function(_) {
					remove(one);
					one.destroy();
				}
			});
		}
	});
}