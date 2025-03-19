extends CharacterBody2D

const SPEED = 100.0
const ATTACK_RANGE = 100  # Distância para atacar o jogador
const ATTACK_DAMAGE = 10  # Dano do ataque
const ATTACK_COOLDOWN = 1.0  # Tempo de espera entre os ataques
const LEFT_LIMIT = -2  # Limite à esquerda para o movimento
const RIGHT_LIMIT = 2  # Limite à direita para o movimento

var animated_sprite: AnimatedSprite2D
var player: CharacterBody2D
var attack_timer: Timer
var is_attacking: bool = false
var direction: int = 1  # Direção do movimento, 1 = direita, -1 = esquerda

func _ready():
	# Referências aos nós da árvore
	animated_sprite = $AnimatedSprite2D  # Referência ao AnimatedSprite2D
	attack_timer = $AttackTimer  # Referência ao Timer (AttackTimer)
	player = get_node("/root/Node2D/joão")  # Pegando o jogador (ajuste o caminho, se necessário)

	# Configurações iniciais
	attack_timer.wait_time = ATTACK_COOLDOWN
	
	# Conectar o sinal 'timeout' do Timer à função '_on_attack_timeout'
	attack_timer.connect("timeout", self, "_on_attack_timeout")  # Ajuste para usar 'self' e o método correto

func _physics_process(delta: float) -> void:
	# Movimento do inimigo para a esquerda e direita
	if not is_attacking:
		velocity.x = SPEED * direction

		# Se o inimigo atingir os limites, ele inverte a direção
		if position.x <= LEFT_LIMIT or position.x >= RIGHT_LIMIT:
			direction *= -1
			flip_enemy_direction()

		# Se o jogador estiver dentro do alcance, inicia o ataque
		if position.distance_to(player.position) <= ATTACK_RANGE:
			attack_player()

		# Atualiza animação conforme o movimento
		if direction == 1:
			if animated_sprite.animation != "run":
				animated_sprite.play("run")
		else:
			if animated_sprite.animation != "run":
				animated_sprite.play("run")

	move_and_slide()

# Função para atacar o jogador
func attack_player():
	if not is_attacking and attack_timer.is_stopped():
		is_attacking = true
		animated_sprite.play("attack")
		attack_timer.start()

		# Dano ao jogador
		if position.distance_to(player.position) <= ATTACK_RANGE:
			# Aplicar dano no jogador (chame a função de dano do jogador aqui)
			player.take_damage(ATTACK_DAMAGE)

# Função chamada quando o Timer expira
func _on_attack_timeout():
	# Finaliza o ataque e volta para a animação anterior
	is_attacking = false
	animated_sprite.play("idle")  # Volta para a animação idle (ajuste conforme necessário)

# Função para virar o inimigo de acordo com a direção
func flip_enemy_direction():
	animated_sprite.flip_h = direction == -1
