extends Control

onready var tween = $Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	tween.interpolate_property(
		$Label, 'rect_scale', 
		Vector2(0.5,0.5), Vector2(1,1),
		1,
		Tween.TRANS_ELASTIC,
		Tween.EASE_OUT
	);
	tween.start()
	
	

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

