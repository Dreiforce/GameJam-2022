extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_color(itemType):
	$Label.self_modulate = get_score_color(itemType)

func get_score_color(itemType):
	match itemType:
		0:
			return Color("#000000")
		1:
			return Color("#C20000")
		2:
			return Color("#2288FF")
