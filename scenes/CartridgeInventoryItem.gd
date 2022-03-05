extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_count(value):
	$CartridgeCount.text = str(value)

func set_texture(itemType):
	var texture
	match itemType:
		0:
			texture = load("res://art/progress_bar/Cartridges/cartridge_black.png")
		1:
			texture = load("res://art/progress_bar/Cartridges/cartridge_red.png")
		2:
			texture = load("res://art/progress_bar/Cartridges/cartridge_black.png")
		3:
			texture = load("res://art/progress_bar/Cartridges/cartridge_blue.png")
			
	$CartridgeSprite.set_texture(texture)
