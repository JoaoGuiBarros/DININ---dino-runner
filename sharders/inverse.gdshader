shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float transition : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 color = texture(screen_texture, SCREEN_UV);
    
    vec3 inverted_color = 1.0 - color.rgb;
    
    color.rgb = mix(color.rgb, inverted_color, transition);
    
    COLOR = color;
}
