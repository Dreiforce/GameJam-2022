extends CanvasLayer

signal start_game
signal pause_game
signal game_over

export(PackedScene) var progress_bar
export(PackedScene) var inventory_item

var printer = {}
var inventory_list = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/PauseButton.hide()
	$ProgressBars.add_constant_override("separation", 17)
	$Inventory.add_constant_override("separation", 20)

func show_message(text, start_timer=true):
	$Control/Message.text = text
	$Control/Message.show()
	if start_timer:
		$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")

	$Control/Message.text = "Nice try"
	$Control/Message.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	emit_signal("game_over")
	
func show_main_menu():
	$Control/StartButton.show()

func update_score(score):
	$Control/ScoreLabel.text = str(score)
	
func update_inventory(inventory):
	for item in inventory:	
		if !inventory_list.has(item):
			var inv_item = inventory_item.instance()
			inventory_list[item] = inv_item
			inv_item.set_texture(item)
			$Inventory.add_child(inv_item)
			
		inventory_list[item].update_count(inventory[item])

func update_printer(inventory):
	for item in inventory:
		if !printer.has(item):
			var color_bar = progress_bar.instance()
			printer[item] = color_bar
			$ProgressBars.add_child(color_bar)
			color_bar.set_progress(item)
			color_bar.update_ProgressBar(inventory[item] * 10)
			color_bar.start_timer()
		else:
			printer[item].add_ProgressBar(inventory[item] * 10)
		
	print(printer)
	return printer

func _on_StartButton_pressed():
	$Control/StartButton.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Control/Message.hide()

func _on_PauseButton_pressed():
	$Control/PauseButton.hide()
	emit_signal("pause_game")
