shader_type spatial;

void fragment() {
	ALBEDO = COLOR.rgb;
	EMISSION = COLOR.rgb * NORMAL.b * 10.0;
	ALPHA = pow(NORMAL.b, 10.0) * COLOR.a;
}
