extends Node2D

@onready var spawn_timer = $SpawnTimer
const preload_cloud = preload("res://scenes/cloud.tscn")

func _ready() -> void:
	randomize()
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	start_spawn_timer()
	
func start_spawn_timer():

	spawn_timer.wait_time = randf_range(0, 5)
	spawn_timer.start()
	
func on_spawn_timer_timeout() -> void:

	var cloud = preload_cloud.instantiate()
	cloud.position = Vector2(301, round(randf_range(20, 50)))
	cloud.speed_scale = randf_range(0.2,0.4)
	cloud.scale = Vector2(randf_range(0.8,1.2), randf_range(0.8,1.2))
	add_child(cloud)
	
	start_spawn_timer()
