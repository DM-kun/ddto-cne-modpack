package;

class WiggleEffect
{
	public var shader(default, null):CustomShader = new CustomShader('wiggle');
	public var waveSpeed(default, set):Float = 0;
	public var waveFrequency(default, set):Float = 0;
	public var waveAmplitude(default, set):Float = 0;
	public var effectType(default, set):Int = 0;

	public function new(speed:Float, frequency:Float, amplitude:Float, type:Int):Void
	{
		shader.uTime = 0;
		waveSpeed = speed;
		waveFrequency = frequency;
		waveAmplitude = amplitude;
		effectType = type;
	}

	public function update(elapsed:Float):Void
	{
		shader.uTime += elapsed;
	}

	function set_waveSpeed(v:Float):Float
	{
		shader.uSpeed = v;
		return waveSpeed = v;
	}

	function set_waveFrequency(v:Float):Float
	{
		shader.uFrequency = v;
		return waveFrequency = v;
	}

	function set_waveAmplitude(v:Float):Float
	{
		shader.uWaveAmplitude = v;
		return waveAmplitude = v;
	}

	function set_effectType(v:Int):Int
	{
		shader.effectType = v;
		return effectType = v;
	}
}