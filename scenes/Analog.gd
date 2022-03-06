extends Node2D

var index:int = -1
export var max_distance:float = 12.0

signal analog_touch(touching)
signal analog_move(direction)

func ready():
	$Outer.hide()


func _input(event):
	if !(event is InputEventScreenTouch || event is InputEventScreenDrag):
		return

	# Only set index if there is nothing assigned
	if index == -1:
		if event is InputEventScreenTouch && event.pressed:
			index = event.index
			$Outer.position = event.position
			$Outer.show()
			emit_signal('analog_touch', true)

	# Return early so we don't process unecessary events.
	if index == -1 || event.index != index:
		return

	# Finish the drag
	if event is InputEventScreenTouch && !event.pressed:
		index = -1
		$Outer/Inner.position = Vector2(0,0)
		$Outer.hide()
		emit_signal('analog_touch', false)
		return

	# Follow the touch
	$Outer/Inner.position = (event.position - $Outer.position).clamped(max_distance)
	


	# this will set the intensity between 0 and 1
	var intensity = $Outer/Inner.position.length() / max_distance
	var direction = $Outer/Inner.position.normalized()
	emit_signal('analog_move', direction * intensity)
