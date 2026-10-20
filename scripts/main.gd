extends Node2D

@onready var runner = $Runner
@onready var player = $Runner/Player
@onready var central_title = $UI/CentralText
@onready var score_label = $UI/Score
@onready var death_sfx = $DeathSfx
@onready var interact_sfx = $InteractSfx
@onready var score_hit_sfx = $ScoreHitSfx
@onready var score_frezze = $UI/ScoreFrezze

enum state {START, RUNNING, RESET}

var score: float = 0.0
var high_score: float = 0.0
var points_per_second: float = 150
var game_speed: float = -150
var update_score := true
var game_state: = state.START

func _ready() -> void:
	score_frezze.timeout.connect(_on_score_frezze_timeout)
	score_frezze.one_shot = true

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
				
		if int(floor(score)) % 1500 == 0 and score != 0 and update_score:
			score_hit_sfx.play()
			update_score = false
			score_frezze.wait_time = 1
			score_frezze.start()
			
	if game_state == state.RESET:
		central_title.text = "Press [ENTER] to restart"
		score_label.text = "[color=#6f6f6f]HI %07d[/color] %07d" % [high_score, score]
		
		if high_score == 0:
			high_score = score
		
		if Input.is_action_just_pressed("interact"):
			interact_sfx.play()
			game_state = state.RUNNING
			score = 0
			runner.reset_runner()
	
func _on_score_frezze_timeout() -> void:
	update_score = true
