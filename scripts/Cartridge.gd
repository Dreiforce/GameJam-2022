extends Area2D

signal collect

enum ItemType {
	BLACK,
	RED,
	GREEN,
	BLUE
}

export(ItemType) var itemType = ItemType.BLACK

# Called when the node enters the scene tree for the first time.
func _ready():
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
	
	$Sprite.set_texture(texture)

func _on_Cartridge_body_entered(body):
	emit_signal("collect", self)
	queue_free()
