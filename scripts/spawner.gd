extends Node2D

@onready var spawn_timer = $SpawnTimer

@onready var cactus_spawn_point = $CactusPoint
@onready var ptero_spawn_points = [$PteroPoint1, $PteroPoint2, $PteroPoint3]

var cactus_arr = [
	preload("res://scenes/cactus_1.tscn"),
	preload("res://scenes/cactus_2.tscn"),
	preload("res://scenes/cactus_3.tscn")
]
var preload_ptero = preload("res://scenes/ptero.tscn")

var spawn_arr: Array[Callable] = [spawn_cactus, spawn_cactus,spawn_ptero]

func _ready() -> void:
	randomize()
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	start_spawn_timer()

func on_spawn_timer_timeout() -> void:
	if get_tree().get_first_node_in_group("main_game").score <= 13500:
		spawn_cactus()
	else:
		spawn_arr.pick_random().call()

	start_spawn_timer()

func start_spawn_timer():
	var score = get_tree().get_first_node_in_group("main_game").score
	spawn_timer.wait_time = randf_range(0.75, 1.75 if score <= 1500 else 1.0)
	spawn_timer.start()

func spawn_cactus():
	var random_cactus = cactus_arr.pick_random()
	var cactus = random_cactus.instantiate()
	cactus.position = cactus_spawn_point.position
	cactus.speed_scale = 1
	get_parent().add_child(cactus)

func spawn_ptero():
	var ptero = preload_ptero.instantiate()
	ptero.position = ptero_spawn_points.pick_random().position
	ptero.speed_scale = 1
	get_parent().add_child(ptero)
