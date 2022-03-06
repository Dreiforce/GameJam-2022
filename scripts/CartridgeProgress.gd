extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_CartridgeTimer_timeout():
	$CartridgeProgressBar.value -= 1

func add_ProgressBar(value):
	$CartridgeProgressBar.value += value

func update_ProgressBar(value):
	$CartridgeProgressBar.value = value
	
func get_ProgressBar_value():
	return $CartridgeProgressBar.value
	
func get_ProgressBar_max_value():
	return $CartridgeProgressBar.get_max()

func start_timer():
	$CartridgeTimer.start()

func set_texture(itemType):
	var texture
	match itemType:
		0:
			texture = load("res://art/progress_bar/Cartridges/progress_black.png")
		1:
			texture = load("res://art/progress_bar/Cartridges/progress_red.png")
		2:
			texture = load("res://art/progress_bar/Cartridges/progress_blue.png")
			
	$CartridgeProgressBar.set_progress_texture(texture)
