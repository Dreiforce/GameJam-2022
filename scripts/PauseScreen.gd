extends CanvasLayer

signal resume_game
signal exit_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_ResumeButton_pressed():
	emit_signal("resume_game")

func _on_ExitButton_pressed():
	emit_signal("exit_game")
