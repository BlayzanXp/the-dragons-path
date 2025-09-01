extends CharacterBody2D

var vida: int = 100
var velocidade: float = 100.0
var distancia_ataque: float = 50.0
var tempo_entre_ataques: float = 1.0  # segundos entre ataques
@export var jogador: Node2D
var timer_ataque: float = 0.0

# Referência ao AnimatedSprite2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	# jogador = get_parent().get_node("Player")
	$Hitbox.body_entered.connect(_on_body_entered)  # sintaxe Godot 4

func _physics_process(_delta: float) -> void:
	if jogador == null:
		return

	timer_ataque -= _delta

	var direcao: Vector2 = jogador.position - position
	var distancia: float = direcao.length()

	if distancia > distancia_ataque:
		# Segue o jogador
		velocity = direcao.normalized() * velocidade
		move_and_slide()
		anim.play("idle")
	else:
		# Está perto, ataque
		velocity = Vector2.ZERO
		move_and_slide()
		atacar_jogador()

func atacar_jogador() -> void:
	if timer_ataque <= 0:
		if jogador != null and jogador.has_method("receber_dano"):
			jogador.receber_dano(10)
			print("Inimigo atacou o jogador!")
			timer_ataque = tempo_entre_ataques

func receber_dano(valor: int) -> void:
	vida -= valor
	anim.play("hit")
	if vida <= 0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.name == "Player" and body.has_method("receber_dano"):
		body.receber_dano(5)
