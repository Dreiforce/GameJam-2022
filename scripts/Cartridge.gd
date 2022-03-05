extends Area2D

signal collect

enum ItemType {
	BLACK,
	RED,
	GREEN,
	BLUE
}

export(String, FILE) var itemIcon = "."
export(ItemType) var itemType = ItemType.BLACK

# Called when the node enters the scene tree for the first time.
func _ready():
	var image = load(itemIcon)
	$Sprite.set_texture(image)

func _on_Cartridge_body_entered(body):
	emit_signal("collect", self)
	queue_free()
