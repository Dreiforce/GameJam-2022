extends Node

export(PackedScene) var cartridge
export var cartridges = 100
export var cartridge_multiplier = 10
export var cartridge_spawn_retries = 8
var score

var inventory = {}
var printer = {}
var rng = RandomNumberGenerator.new()
var cartridge_list = []
var scores = []


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.set_seed(1234)
	get_tree().paused = true
	$Player.start($StartPosition.position)
	$Printer/AnimatedSprite.play()
	$MenuPausePlayer.play()
	scores = load_score()

func game_over():
	$ScoreTimer.stop()
	$CartridgeSpawnTimer.stop()
	$HUD.show_game_over()
	append_score(score)
	print("scores: " + str(scores))

func new_game():
	get_tree().paused = false
	reset_score()
	cartridge_list.clear()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD._on_MessageTimer_timeout()
	$HUD.start_game()
	generate_cartridges()
	initialize_printer()
	add_objects_tp_scene()
	$CartridgeSpawnTimer.start()
	
	$MenuPausePlayer.stop()
	$MainSoundPlayer.play()
	
func initialize_printer():
	var inv_item = $HUD.add_inventory_color(0)
	inventory[0] = inv_item
	inventory[0].set_count(10)
	_on_Printer_fill()

func _on_ScoreTimer_timeout():
	var score_points = []
	for itemType in printer:
		if printer[itemType].get_ProgressBar_value() > 0:
			score_points.append(itemType)
	
	if score_points.size() == 0:
		game_over()
	
	for i in score_points:
		score += i + 1 #score = (itemType + 1)
	
	$HUD.update_score(score, score_points)

func _on_StartTimer_timeout():
	$ScoreTimer.start()

func _on_HUD_pause_game():
	get_tree().paused = true
	$PauseScreen/Popup.show()
	
	$MainSoundPlayer.stop()
	$MenuPausePlayer.play()

func _on_PauseScreen_resume_game():
	get_tree().paused = false
	$PauseScreen/Popup.hide()
	$HUD/Control/PauseButton.show()
	
	$MenuPausePlayer.stop()
	$MainSoundPlayer.play()
	
func _on_PauseScreen_exit_game():
	get_tree().paused = false
	get_tree().reload_current_scene()

func reset_score():
	score = 0
	$HUD.update_score(score, [])

func _on_Cartridge_collect(item):	
	$PickupSound.play()
	
	if !inventory.has(item.itemType):
		var inv_item = $HUD.add_inventory_color(item.itemType)
		inventory[item.itemType] = inv_item
	
	cartridge_list.erase(item)
	
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

func _on_CartridgeSpawnTimer_timeout():
	for i in range(cartridge_spawn_retries):
		if(generate_one_cartridge()):
			break

# [TODO] Rarity and respawn
func generate_cartridges():
	for i in range(cartridges):
		generate_one_cartridge()


func generate_one_cartridge():
	var item = cartridge.instance()
	item.connect("collect", self, "_on_Cartridge_collect")
	
	var size = $TileMap.tile_size * $TileMap.world_size * $TileMap.chunk_size
	var x = rng.randi_range(10, size)
	var y = rng.randi_range(10, size)
	
	var abstand_home_in_percent = Vector2(x,y).length() / Vector2(size,size).length() 
	var rarity = int(clamp(abstand_home_in_percent * 6, 0, 5))#TODO constants, this distributes the rarity evenly on the board (ie highest only in the outer 1/6 
	item.itemType = rng.randi_range(0, rarity)
	
	if check_surroundings(x, y):
		item.position = Vector2(x, y)
		add_child(item)
		cartridge_list.append(item)
		print("created cartridge at " + str(x) +  " " + str(y) 
			+ " with dist% " + str(abstand_home_in_percent) 
			+ " with rarity " + str(rarity) 
			+ " and now have " + str(cartridge_list.size()) + " on the map"
		)
		return true
	return false


func check_surroundings(x, y):
	#if on wall
	for i in range(-10, 10):
		for j in range(-22, 22):
			var coordinates = $TileMap.world_to_map(Vector2(x+i, y+j))
			var tile_index = $TileMap.get_cell(coordinates.x, coordinates.y)
			if tile_index != 1 or $StartPosition.position == coordinates:
				return false
	
	#if already card near here
	for cart in cartridge_list:
		if(Vector2(x,y).distance_squared_to(cart.position) < pow(16 * 5, 2)): # 5 tiles x 16 pixel squared
			return false;
	
	return true


func save_score(scores):
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(to_json(scores))

func load_score():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return [0,0,0] # init
	save_game.open("user://savegame.save", File.READ)
	var node_data = parse_json(save_game.get_line())
	save_game.close()
	return node_data

func sort_descending(a, b):
	if a > b:
		return true
	return false

func append_score(score):
	scores.append(score)
	scores.sort_custom(self, "sort_descending")
	while(scores.size() > 3):
		scores.remove(3)
	save_score(scores)

func add_objects_tp_scene():
	#TODO remove children for reset $ingame_objects.remove_child()
	var rng = RandomNumberGenerator.new()
	rng.set_seed(1234)
	
	
	for i in range(0, $TileMap.world_size):
		for j in range(0, $TileMap.world_size):
			if(i != 0 and j != 0):
				var x = rng.randi_range(1,$TileMap.chunk_size-1) + i * $TileMap.chunk_size
				var y = rng.randi_range(1,$TileMap.chunk_size-1) + j * $TileMap.chunk_size
				var table = load("res://scripts/CollisionBoxItems.gd").new()
				if(table.test_position($TileMap,x,y)):
					table.position = Vector2(
						x * $TileMap.tile_size,
						y * $TileMap.tile_size
					)
					add_child_below_node($ingame_objects,table)

