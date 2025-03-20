extends Camera2D

@onready var tilemap = $"../TileMap"  # Caminho para o TileMap

func _ready():
	if tilemap:
		var mapa_limites = tilemap.get_used_rect()  # Obtém o tamanho do mapa
		var tile_size = tilemap.tile_set.tile_size  # Tamanho do tile

		limit_left = mapa_limites.position.x * tile_size.x
		limit_top = mapa_limites.position.y * tile_size.y
		limit_right = (mapa_limites.end.x * tile_size.x) - int(get_viewport_rect().size.x)
		limit_bottom = (mapa_limites.end.y * tile_size.y) - int(get_viewport_rect().size.y)
 
