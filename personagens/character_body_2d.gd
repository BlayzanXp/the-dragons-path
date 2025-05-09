extends CharacterBody2D

@export var speed: float = 100
@export var health: int = 10
@export var attack_distance: float = 30
@export var damage: int = 1

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea  # Área de ataque (hitbox)

var is_attacking = false

# Função de movimento do personagem
func _physics_process(delta):
	var velocity = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		velocity.x += speed
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
	if Input.is_action_pressed("move_up"):
		velocity.y -= speed
	if Input.is_action_pressed("move_down"):
		velocity.y += speed

	# Movimenta o personagem
	move_and_slide(velocity)  # Aqui, você passa apenas a variável velocity
	update_animation(velocity)

# Atualiza as animações do personagem
func update_animation(velocity):
	if velocity.length() > 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")

# Função de input para realizar o ataque
func _input(event):
	if event.is_action_pressed("attack"):  # Defina no Input Map em Project Settings
		attack()

# Função para iniciar o ataque do personagem
func attack():
	if not is_attacking:
		is_attacking = true
		animated_sprite.play("attack1")  # Animação de ataque
		attack_area.visible = true  # Torna a área de ataque visível
		check_attack_collision()  # Verifica colisão com inimigos

# Verifica colisão do ataque do personagem com inimigos
func check_attack_collision():
	for body in attack_area.get_overlapping_bodies():
		if body.is_in_group("inimigos"):  # Verifica se é um inimigo
			body.take_damage(damage)  # Aplica o dano no inimigo

# Função para tomar dano no personagem
func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()  # Chama função de morte

# Função de morte do personagem
func die():
	queue_free()  # Remove o personagem da cena quando morrer

# Função chamada quando a animação de ataque termina
func _on_AnimatedSprite2D_animation_finished():
	if animated_sprite.animation == "attack1":
		attack_area.visible = false  # Esconde a área de ataque após o fim da animação
		is_attacking = false
