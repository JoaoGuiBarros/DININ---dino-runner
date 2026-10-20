extends CharacterBody2D

@onready var parallax_background := $Parallax2D

func _process(_delta: float) -> void:

	parallax_background.autoscroll.x = get_parent().get_parent().game_speed
