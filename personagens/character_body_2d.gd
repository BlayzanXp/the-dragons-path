extends CharacterBody2D

@export var speed: float = 100
@export var health: int = 10
@export var attack_distance: float = 30
@export var damage: int = 1

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = get_node("/root/Main/personagens/Player")  # Ajuste o caminho conforme seu projeto

var is_attacking = false

func _physics_process(delta):
	if not player or health <= 0:
		return

	var distance_to_player = global_position.distance_to(player.global_position)

	if distance_to_player > attack_distance:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		animated_sprite.play("walk")
	else:
		velocity = Vector2.ZERO
		if not is_attacking:
			is_attacking = true
			animated_sprite.play("attack")

	move_and_slide()

func _on_AnimatedSprite2D_animation_finished():
	if animated_sprite.animation == "attack":
		is_attacking = false
		if global_position.distance_to(player.global_position) <= attack_distance:
			player.take_damage(damage)

	elif animated_sprite.animation == "hit":
		if health > 0:
			animated_sprite.play("idle")

func take_damage(amount: int):
	health -= amount
	animated_sprite.play("hit")
	if health <= 0:
		queue_free()
