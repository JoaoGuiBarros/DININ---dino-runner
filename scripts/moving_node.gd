extends CharacterBody2D

var speed_scale: float = 1.0

func _physics_process(delta: float) -> void:
	
	var speed = get_tree().get_first_node_in_group("main_game").game_speed
	position.x += (speed * speed_scale) * delta

	if position.x <= -100: 
		queue_free()
