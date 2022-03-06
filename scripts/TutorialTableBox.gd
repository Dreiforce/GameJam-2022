extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.hide()
	$Label2.hide()

func _on_Area2D_body_entered(body):
	$Label.show()
	$Label2.show()

func _on_Area2D_body_exited(body):
	$Label.hide()
	$Label2.hide()
