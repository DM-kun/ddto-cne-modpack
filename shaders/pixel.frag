#pragma header

vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;

uniform float value;

void main()
{
	gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
	if(value == 0.0) {return;}

	vec2 pixel_count = max(floor(iResolution.xy * vec2((cos(value) + 1.0) / 2.0)), 1.0);
	vec2 pixel_size = iResolution.xy / pixel_count;
	vec2 pixel = (pixel_size * floor(fragCoord / pixel_size)) + (pixel_size / 1.0);
	vec2 uv = pixel.xy / iResolution.xy;

	gl_FragColor = vec4(flixel_texture2D(bitmap, uv).xyz, 1.0);
}