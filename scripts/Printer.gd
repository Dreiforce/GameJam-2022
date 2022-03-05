extends StaticBody2D

signal fill

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Area2D_body_entered(body):
	emit_signal("fill")
