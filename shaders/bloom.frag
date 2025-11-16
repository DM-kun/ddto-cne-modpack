#pragma header

vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;

uniform float range;
uniform float steps;
uniform float threshhold;
uniform float brightness;

void main() {
	vec2 uv = fragCoord / openfl_TextureSize.xy;
	gl_FragColor = flixel_texture2D(bitmap, uv);

	for (float i = -range; i < range; i += steps) {
		float falloff = 1.0 - abs(i / range);
		vec4 blur = flixel_texture2D(bitmap, uv + i);
		if (blur.r + blur.g + blur.b > threshhold * 3.0) {
			gl_FragColor += blur * falloff * steps * brightness;
		}

		blur = flixel_texture2D(bitmap, uv + vec2(i, -i));
		if (blur.r + blur.g + blur.b > threshhold * 3.0) {
			gl_FragColor += blur * falloff * steps * brightness;
		}
	}
}