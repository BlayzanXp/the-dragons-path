extends Camera2D

@onready var player = get_node("/root/Node2D/Node2D/CharacterBody2D/Player")  # Caminho absoluto

# Definindo o tamanho do mapa
var mapa_largura = 1920  # Largura do mapa
var mapa_altura = 1080  # Altura do mapa

func _ready():
	# Certifique-se de que a câmera está configurada para seguir o jogador.
	offset = Vector2(0, 0)

func _process(_delta):  # Agora o delta é ignorado
	# Acompanhar o jogador
	var nova_pos = player.position
	
	# Limitar a posição da câmera no eixo X (horizontal)
	nova_pos.x = clamp(nova_pos.x, mapa_largura / 2.0, mapa_largura - mapa_largura / 2.0)
	
	# Limitar a posição da câmera no eixo Y (vertical)
	nova_pos.y = clamp(nova_pos.y, mapa_altura / 2.0, mapa_altura - mapa_altura / 2.0)
	
	# Aplicar a posição calculada à câmera
	position = nova_pos
