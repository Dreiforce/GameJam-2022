extends CanvasLayer

signal start_game
signal pause_game

export(PackedScene) var progress_bar

var colors = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/PauseButton.hide()

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
	show_main_menu()
	
func show_main_menu():
	$Control/StartButton.show()

func update_score(score):
	$Control/ScoreLabel.text = str(score)
	
func update_printer(inventory):
	for item in inventory:
		if !colors.has(item):
			var color_bar = progress_bar.instance()
			colors[item] = color_bar
			$ProgressBars.add_child(color_bar)
			color_bar.update_ProgressBar(inventory[item] * 20)
			color_bar.start_timer()
		else:
			colors[item].add_ProgressBar(inventory[item] * 20)
	print(colors)

func _on_StartButton_pressed():
	$Control/StartButton.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Control/Message.hide()

func _on_PauseButton_pressed():
	$Control/PauseButton.hide()
	emit_signal("pause_game")
