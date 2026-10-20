extends CharacterBody2D

@onready var sprite := $AnimatedSprite2D
@onready var normal_collisionshape = $StraightCollision
@onready var duck_collisionshape = $DuckingCollision
@onready var jump_sfx: AudioStreamPlayer2D = $JumpSfx

const jump_velocity := -320
var is_dead = false

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		if sprite.animation != "jumping":
			sprite.play("jumping")

		var gravity := get_gravity() if not Input.is_action_pressed("duck") else get_gravity() * 2.5
		velocity += gravity * delta

		var jump_cancel = Input.is_action_just_released("jump") or Input.is_action_just_pressed("duck")
		if (jump_cancel) and velocity.y < 0:
			velocity.y = 0
	else:
		var is_ducking = Input.is_action_pressed("duck")

		normal_collisionshape.disabled = is_ducking
		duck_collisionshape.disabled = not is_ducking

		if is_ducking:
			if sprite.animation != "ducking":
				sprite.play("ducking") 
		else:
			if sprite.animation != "running":
				sprite.play("running") 

		if Input.is_action_pressed("jump") and not Input.is_action_pressed("duck"):
			velocity.y = jump_velocity
			jump_sfx.pitch_scale = randf_range(0.8,1.2)
			jump_sfx.play()

	move_and_slide()

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("obstacle"):
			die()

func die():
	if is_dead:
		return

	position.x = 16
	is_dead = true
	sprite.play("dying")

	get_parent().process_mode = Node.PROCESS_MODE_DISABLED
