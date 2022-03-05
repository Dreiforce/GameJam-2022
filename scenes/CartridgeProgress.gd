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

func start_timer():
	$CartridgeTimer.start()
