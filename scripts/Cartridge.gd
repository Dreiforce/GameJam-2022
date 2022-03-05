extends Area2D

signal collect

var itemIcon
var itemType = ItemType.BLACK

enum ItemType {
	BLACK = 0,
	RED = 1,
	GREEN = 2,
	BLUE = 3
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Cartridge_body_entered(body):
	emit_signal("collect", self)
	queue_free()
