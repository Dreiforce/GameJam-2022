extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_color(itemType):
	$Label.self_modulate = get_score_color(itemType)
	$Label.text = "+" + str(itemType + 1)

func get_score_color(itemType):
	match itemType:
		0:
			return Color("#000000")
		1:
			return Color("#C20000")
		2:
			return Color("#2288FF")
		3:
			return Color("#05f60a")
		4:
			return Color("#f605aa")
		5: 
			return Color("#c5c5c5")
