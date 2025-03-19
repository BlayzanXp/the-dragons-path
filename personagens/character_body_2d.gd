extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

var gravity = 800
var jump_strength = -400
var walk_speed = 100
var run_speed = 200
var is_jumping = false

func _ready():
	animated_sprite.play("idle")

func _process(delta):
	if not is_jumping:
		if not is_on_floor():
			velocity.y += gravity * delta
		else:
			if is_jumping:
				velocity.y = 0
				is_jumping = false
			else:
				velocity.y = 0

	if Input.is_action_pressed("ui_right"):
		velocity.x = walk_speed
		animated_sprite.flip_h = false

		if Input.is_action_pressed("ui_shift"):
			velocity.x = run_speed
			if not animated_sprite.is_playing() or animated_sprite.animation != "run":
				animated_sprite.play("run")
		else:
			if not animated_sprite.is_playing() or animated_sprite.animation != "walk":
				animated_sprite.play("walk")

	elif Input.is_action_pressed("ui_left"):
		velocity.x = -walk_speed
		animated_sprite.flip_h = true

		if Input.is_action_pressed("ui_shift"):
			velocity.x = -run_speed
			if not animated_sprite.is_playing() or animated_sprite.animation != "run":
				animated_sprite.play("run")
		else:
			if not animated_sprite.is_playing() or animated_sprite.animation != "walk":
				animated_sprite.play("walk")

	else:
		velocity.x = 0
		if not animated_sprite.is_playing() or animated_sprite.animation != "idle":
			animated_sprite.play("idle")

	if velocity.y > 0:
		if not animated_sprite.is_playing() or animated_sprite.animation != "fall":
			animated_sprite.play("fall")
	else:
		if is_on_floor():
			if not animated_sprite.is_playing() or animated_sprite.animation != "idle":
				animated_sprite.play("idle")

	move_and_slide()

func _on_jump_input():
	if is_on_floor() and not is_jumping:
		velocity.y = jump_strength
		is_jumping = true
		animated_sprite.play("jump")
