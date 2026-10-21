shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// Variável que controla a transição (0.0 = normal, 1.0 = totalmente invertido)
uniform float transition : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 color = texture(screen_texture, SCREEN_UV);
    
    // Calcula como seria a cor invertida
    vec3 inverted_color = 1.0 - color.rgb;
    
    // Mistura a cor normal com a invertida baseada no valor de "transition"
    color.rgb = mix(color.rgb, inverted_color, transition);
    
    COLOR = color;
}