extends HBoxContainer
tool

var full_heart = preload("res://Assets/kenney_pixelplatformer/Tiles/tile_0044.png")
var half_heart = preload("res://Assets/kenney_pixelplatformer/Tiles/tile_0045.png")
var empty_heart = preload("res://Assets/kenney_pixelplatformer/Tiles/tile_0046.png")

var hearts = [empty_heart, half_heart, full_heart]
onready var textures = [$TextureRect, $TextureRect2, $TextureRect3]

func renderHearts(health):
	
	var sub
	
	for tex in textures:
		
		sub = clamp(health, 0, 2)
		tex.texture = hearts[sub]
		health -= sub
