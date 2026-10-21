extends Node2D

@onready var runner = $Runner
@onready var player = $Runner/Player
@onready var central_title = $UI/CentralText
@onready var score_label = $UI/Score
@onready var death_sfx = $DeathSfx
@onready var interact_sfx = $InteractSfx
@onready var score_hit_sfx = $ScoreHitSfx
@onready var score_frezze = $UI/ScoreFrezze
@onready var sharder = $CanvasLayer/ColorRect
enum state {START, RUNNING, RESET}

var score: float = 0.0
var high_score: float = 0.0
var points_per_second: float = 150
var game_speed: float = -150
var next_milestone: int = 1500
var shader_milestone: int = 9000
var update_score := true
var game_state: = state.START
var is_day := true

func _ready() -> void:
	score_frezze.timeout.connect(_on_score_frezze_timeout)
	score_frezze.one_shot = true
	
	high_score = SaveManager.high_score

func _process(delta: float) -> void:
	score_label.bbcode_enabled = true

	if game_state == state.START:
		central_title.text = "Press [ENTER] to start" 

		if Input.is_action_just_pressed("interact"):
			interact_sfx.play()
			game_state = state.RUNNING
			runner.process_mode = Node.PROCESS_MODE_INHERIT

	if player:
		if player.is_dead and game_state != state.RESET:
			game_state = state.RESET
			death_sfx.play()
			
			if score > SaveManager.high_score:
				SaveManager.save_high_score(int(score))

	if game_state == state.RUNNING:
		central_title.text = ""

		score += points_per_second * delta
		if score > high_score and high_score != 0:
			high_score = score

		game_speed = max((150 + score/100) * -1, -500)

		if update_score:
			if high_score == 0:
				score_label.text = "%07d" % [score]
			else:
				score_label.text = "[color=#6f6f6f]HI %07d[/color] %07d" % [high_score, score]
		else:
			if high_score == 0:
				score_label.text = "%07d" % [int(score / 1500) * 1500]
			else:
				var hi_score_value = int(high_score / 1500) * 1500 if high_score == score else high_score
				score_label.text = "[color=#6f6f6f]HI %07d[/color] %07d" % [hi_score_value, int(score / 1500) * 1500]

		if score >= next_milestone:
			next_milestone += 1500

			if update_score:
				score_hit_sfx.play()
				update_score = false
				score_frezze.wait_time = 1
				score_frezze.start()

		if score >= shader_milestone:
			shader_milestone += 9000
			is_day = not is_day
			var tween = create_tween()

			if is_day:
				tween.tween_property(sharder.material, "shader_parameter/transition", 0.0, 1.0)
			else:
				sharder.visible = true
				tween.tween_property(sharder.material, "shader_parameter/transition", 1.0, 1.0)

	if game_state == state.RESET:
		central_title.text = "Press [ENTER] to restart"
		score_label.text = "[color=#6f6f6f]HI %07d[/color] %07d" % [high_score, score]
		
		if high_score == 0:
			high_score = score

		if Input.is_action_just_pressed("interact"):
			interact_sfx.play()
			game_state = state.RUNNING
			score = 0
			is_day = true
			sharder.material.set_shader_parameter("transition", 0.0)
			sharder.visible = false
			next_milestone = 1500
			shader_milestone = 9000
			update_score = true
			runner.reset_runner()

func _on_score_frezze_timeout() -> void:
	update_score = true
