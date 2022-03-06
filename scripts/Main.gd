extends Node

export(PackedScene) var cartridge
export var cartridges = 100
export var cartridge_multiplier = 10
var score

var inventory = {}
var printer = {}
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.set_seed(1234)
	get_tree().paused = true
	$Player.start($StartPosition.position)

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
	var inv_item = $HUD.add_inventory_color(0)
	inventory[0] = inv_item
	inventory[0].set_count(10)
	_on_Printer_fill()
	$Printer/AnimatedSprite.play()

func _on_ScoreTimer_timeout():
	var score_points = []
	for itemType in printer:
		if printer[itemType].get_ProgressBar_value() > 0:
			score_points.append(itemType)
	
	if score_points.size() == 0:
		game_over()
			
	score += score_points.size()
	$HUD.update_score(score, score_points)

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
	$HUD.update_score(score, [])

func _on_Cartridge_collect(item):	
	if !inventory.has(item.itemType):
		var inv_item = $HUD.add_inventory_color(item.itemType)
		inventory[item.itemType] = inv_item
	
	inventory[item.itemType].update_count(1)

func _on_Printer_fill():
	for itemType in inventory:
		if inventory[itemType].get_count() > 0:
			if !printer.has(itemType):
				printer[itemType] = $HUD.add_printer_color(itemType)
				printer[itemType].connect("remove_color", self, "_on_ProgressBar_done")
				printer[itemType].update_ProgressBar(0)
				printer[itemType].start_timer()
				
			fill_printer(inventory, itemType, printer[itemType])

func _on_ProgressBar_done(itemType):
	printer.erase(itemType)

func fill_printer(inventory, item, color_bar):
	var current_progress = color_bar.get_ProgressBar_value()
	var difference = color_bar.get_ProgressBar_max_value() - current_progress
	var update_progress = inventory[item].get_count() * cartridge_multiplier
	if update_progress < difference:
		color_bar.update_ProgressBar(current_progress + update_progress)
		inventory[item].update_count(-update_progress / cartridge_multiplier)
	elif difference > cartridge_multiplier:
		color_bar.update_ProgressBar(current_progress + difference)
		inventory[item].update_count(-difference / cartridge_multiplier)

func _on_HUD_game_over():
	get_tree().reload_current_scene()

func generate_cartridges():
	for i in range(cartridges):
		var item = cartridge.instance()
		item.connect("collect", self, "_on_Cartridge_collect")
		item.itemType = rng.randi_range(0, 2)
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
		for j in range(-15, 15):
			var coordinates = $TileMap.world_to_map(Vector2(x+i, y+j))
			var tile_index = $TileMap.get_cell(coordinates.x, coordinates.y)
			if tile_index != 1 or $StartPosition.position == coordinates:
				return false
	return true
