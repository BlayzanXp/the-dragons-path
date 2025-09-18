extends CharacterBody2D

var vida: int = 100
var velocidade: float = 100.0
var distancia_ataque: float = 50.0
var tempo_entre_ataques: float = 1.0  
@export var jogador: Node2D
var timer_ataque: float = 0.0

const DISTANCIA_DETECCAO = 250.0
const GRAVITY = 980.0

var initial_x: float
var patrol_range: float = 50.0
var patrol_direction: int = 1

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	if $Hitbox:
		$Hitbox.body_entered.connect(_on_body_entered)
	initial_x = position.x

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(jogador):
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# Adicionando a gravidade para que o inimigo caia no chão
	velocity.y += GRAVITY * _delta

	var direcao_para_jogador: Vector2 = jogador.position - position
	var distancia_para_jogador: float = direcao_para_jogador.length()

	if distancia_para_jogador < DISTANCIA_DETECCAO:
		# Modo Perseguindo
		timer_ataque -= _delta
		if distancia_para_jogador > distancia_ataque:
			velocity.x = direcao_para_jogador.normalized().x * velocidade
			anim.play("run")
		else:
			velocity.x = 0
			atacar_jogador()
		
		anim.flip_h = direcao_para_jogador.x < 0
	else:
		# Modo Patrulhando
		patrulhar()
	
	move_and_slide()

func patrulhar() -> void:
	if position.x >= initial_x + patrol_range:
		patrol_direction = -1
	elif position.x <= initial_x - patrol_range:
		patrol_direction = 1
	
	velocity.x = patrol_direction * velocidade

	anim.play("run")
	anim.flip_h = patrol_direction == -1

func take_damage(valor: int) -> void:
	vida -= valor
	anim.play("hit")
	if vida <= 0:
		queue_free()

func atacar_jogador() -> void:
	if timer_ataque <= 0:
		if is_instance_valid(jogador) and jogador.has_method("take_damage"):
			jogador.take_damage(10)
			timer_ataque = tempo_entre_ataques

func _on_body_entered(body: Node) -> void:
	if is_instance_valid(body) and body.name == "Player" and body.has_method("take_damage"):
		body.take_damage(5)
