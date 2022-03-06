extends Control

var count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func get_count():
	return count

func set_count(value):
	count = value
	set_text(count)
	
func update_count(value):
	count += value
	set_text(count)
	
func set_text(value):
	$CartridgeCount.text = str(count)

func set_texture(itemType):
	var texture
	match itemType:
		0:
			texture = load("res://art/progress_bar/Cartridges/cartridge_black.png")
		1:
			texture = load("res://art/progress_bar/Cartridges/cartridge_red.png")
		2:
			texture = load("res://art/progress_bar/Cartridges/cartridge_blue.png")
		3:
			texture = load("res://art/progress_bar/Cartridges/cartridge_green.png")
		4:
			texture = load("res://art/progress_bar/Cartridges/cartridge_pink.png")
		5:
			texture = load("res://art/progress_bar/Cartridges/cartridge_white.png")
			
	$CartridgeSprite.set_texture(texture)
