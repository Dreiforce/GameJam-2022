extends Node

var score
var inventory = {}
var printer = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func game_over():
	$ScoreTimer.stop()
	$HUD.show_game_over()

func new_game():
	reset_score()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD._on_MessageTimer_timeout()
	$HUD/Control/PauseButton.show()
	initialize_printer()	
	
func initialize_printer():
	inventory[0] = 5
	_on_Printer_fill()

func _on_ScoreTimer_timeout():
	for item in printer:
		if printer[item].get_ProgressBar_value() > 0:
			score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$ScoreTimer.start()

func _on_HUD_pause_game():
	get_tree().paused = true
	$PauseScreen/Popup.show()

func _on_PauseScreen_resume_game():
	get_tree().paused = false
	$PauseScreen/Popup.hide()
	$HUD/Control/PauseButton.show()

func _on_PauseScreen_exit_game():
	get_tree().paused = false
	get_tree().reload_current_scene()

func reset_score():
	score = 0
	$HUD.update_score(score)

func _on_Cartridge_collect(item):
	if inventory.has(item.itemType):
		inventory[item.itemType] += 1
	else:
		inventory[item.itemType] = 1
	$HUD.update_inventory(inventory)
	print("Inventory:", inventory)

func _on_Printer_fill():
	printer = $HUD.update_printer(inventory)
	for item in inventory:
		inventory[item] = 0
	$HUD.update_inventory(inventory)
