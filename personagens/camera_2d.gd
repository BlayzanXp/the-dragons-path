@onready var camera: Camera2D = $Camera2D
@onready var tilemap: TileMap = $"../TileMap"

func _ready():
	var map_rect = tilemap.get_used_rect()
	var cell_size = tilemap.cell_quadrant_size  # Ou tilemap.tile_set.tile_size se estiver na Godot 4.0+
	
	camera.limit_left = map_rect.position.x * cell_size
	camera.limit_top = map_rect.position.y * cell_size
	camera.limit_right = (map_rect.position.x + map_rect.size.x) * cell_size
	camera.limit_bottom = (map_rect.position.y + map_rect.size.y) * cell_size
