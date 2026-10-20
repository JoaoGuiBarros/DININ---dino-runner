extends Node2D

@onready var player = $Player
@onready var background = $Background/Parallax2D
@onready var spawner = $Spawner

func reset_runner() -> void:
	background.scroll_offset = Vector2.ZERO

	player.is_dead = false
	player.position.x = 16
	player.position.y = 64

	spawner.start_spawn_timer()
	get_tree().call_group("obstacle", "queue_free")
	get_tree().call_group("cloud", "queue_free")
	
	process_mode = Node.PROCESS_MODE_INHERIT
