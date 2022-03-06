extends CanvasLayer

signal start_game
signal pause_game
signal game_over(name)

export(PackedScene) var progress_bar
export(PackedScene) var inventory_item
export(PackedScene) var score_point

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/PauseButton.hide()
	$Control/ScoreLabel.hide()
	$ProgressBars.add_constant_override("separation", 17)
	$Inventory.add_constant_override("separation", 20)
	$ColorLabel.add_constant_override("separation", 17)
	
func show_message(text, start_timer=true):
	$Control/Message.text = text
	$Control/Message.show()
	if start_timer:
		$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")
	show_score()
	
func show_main_menu():
	$Control/StartButton.show()
	
func add_score_point(itemType):
	var point = score_point.instance()
	point.set_color(itemType)
	$ColorLabel.add_child(point)
	return point

func update_score(score, points):
	$Control/ScoreLabel.text = str(score)
	delete_children($ColorLabel)
	for itemType in points:
		add_score_point(itemType)
	
func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
	
func add_inventory_color(itemType):
	var inv_item = inventory_item.instance()
	inv_item.set_texture(itemType)
	$Inventory.add_child(inv_item)
	return inv_item

func add_printer_color(itemType):
	var color_bar = progress_bar.instance()
	color_bar.set_texture(itemType)
	$ProgressBars.add_child(color_bar)
	return color_bar
	
func _on_StartButton_pressed():
	$Control/StartButton.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Control/Message.hide()

func _on_PauseButton_pressed():
	$Control/PauseButton.hide()
	emit_signal("pause_game")

func start_game():
	$Control/PauseButton.show()
	$Control/ScoreLabel.show()

func show_score():
	get_tree().paused = true
	$Control/Message.text = "Name"
	$Control/Message.show()
	$ScoreName.show()
	$ScoreButton.show() 

func _on_ScoreButton_pressed():
	emit_signal("game_over", $ScoreName.text)
