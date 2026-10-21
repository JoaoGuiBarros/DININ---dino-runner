extends Node

var save_path = OS.get_executable_path().get_base_dir() + "/savedata.cfg"
var high_score = 0

func _ready():
	load_high_score()

func save_high_score(new_score: int):
	var config = ConfigFile.new()
	config.set_value("Stats", "high_score", new_score)
	config.save(save_path)

func load_high_score():
	var config = ConfigFile.new()
	var erro = config.load(save_path)

	if erro == OK:
		high_score = config.get_value("Stats", "high_score", 0)
	else:
		high_score = 0
