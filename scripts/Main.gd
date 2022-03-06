extends Node

export(PackedScene) var cartridge
export var cartridges = 100
var score
var inventory = {}
var printer = {}
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.set_seed(1234)
	get_tree().paused = true
	$Player.start($StartPosition.position)
	generate_colissions()

func game_over():
	$ScoreTimer.stop()
	$HUD.show_game_over()

func new_game():
	get_tree().paused = false
	reset_score()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD._on_MessageTimer_timeout()
	$HUD.start_game()
	generate_cartridges()
	initialize_printer()
	
func initialize_printer():
	inventory[0] = 10
	_on_Printer_fill()

func _on_ScoreTimer_timeout():
	var points = 0
	for item in printer:
		if printer[item].get_ProgressBar_value() > 0:
			points += 1
	
	if points <= 0:
		game_over()
			
	score += points
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
	print(item.position)
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

func _on_HUD_game_over():
	get_tree().reload_current_scene()

func generate_cartridges():
	for i in range(cartridges):
		var item = cartridge.instance()
		item.connect("collect", self, "_on_Cartridge_collect")
		item.itemType = rng.randi_range(0, 3)
		var size = $TileMap.tile_size * $TileMap.world_size * $TileMap.chunk_size
		var x = rng.randi_range(10, size)
		var y = rng.randi_range(10, size)
		
		if check_surroundings(x, y):
			item.position = Vector2(x, y)
			add_child(item)
		else:
			cartridges += 1

func check_surroundings(x, y):
	for i in range(-10, 10):
		for j in range(-10, 10):
			var coordinates = $TileMap.world_to_map(Vector2(x+i, y+j))
			var tile_index = $TileMap.get_cell(coordinates.x, coordinates.y)
			if tile_index != 1 or $StartPosition.position == coordinates:
				return false
	return true

func generate_colissions():
	pass
