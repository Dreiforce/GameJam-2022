extends Control

signal remove_color

var itemType

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_CartridgeTimer_timeout():
	$CartridgeProgressBar.value -= 1
	if $CartridgeProgressBar.value <= 0:
		queue_free()
		emit_signal("remove_color", itemType)

func add_ProgressBar(value):
	$CartridgeProgressBar.value += value

func update_ProgressBar(value):
	if($CartridgeProgressBar.value < value):
		$CPUParticles2D.emitting = true
		
	$CartridgeProgressBar.value = value
	
func get_ProgressBar_value():
	return $CartridgeProgressBar.value
	
func get_ProgressBar_max_value():
	return $CartridgeProgressBar.get_max()

func start_timer():
	$CartridgeTimer.start()

func set_texture(item):
	itemType = item
	
	$CPUParticles2D.color = get_score_color(itemType)
	
	var texture
	match itemType:
		0:
			texture = load("res://art/progress_bar/Cartridges/progress_black.png")
		1:
			texture = load("res://art/progress_bar/Cartridges/progress_red.png")
		2:
			texture = load("res://art/progress_bar/Cartridges/progress_blue.png")
		3:
			texture = load("res://art/progress_bar/Cartridges/progress_green.png")
		4:
			texture = load("res://art/progress_bar/Cartridges/progress_pink.png")
		5:
			texture = load("res://art/progress_bar/Cartridges/progress_white.png")
			
	$CartridgeProgressBar.set_progress_texture(texture)


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
