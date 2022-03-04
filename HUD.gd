extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_message(text):
	$Control/Message.text = text
	$Control/Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")

	$Control/Message.text = "Nice try"
	$Control/Message.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$Control/StartButton.show()

func update_score(score):
	$Control/ScoreLabel.text = str(score)

func _on_StartButton_pressed():
	$Control/StartButton.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Control/Message.hide()
