extends TileMap

var rng = RandomNumberGenerator.new()
	
func generate_matrix(val = 0):
	var matrix = []
	for x in range(chunk_size):
		matrix.append([])
		for y in range(chunk_size):
			matrix[x].append(val)
	return matrix
# Declare member variables here. Examples:
# var a = 2
# var b = "text"




# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	seed_value = rng.randi_range(0, 100)
	main()
	update_dirty_quadrants()
	update_bitmask_region()
	

##### INSERT GENERATOR HERE
var seed_value = 0
var tile_size = 16
var chunk_size = 16
var world_size = 10
var WALL = 0
var FLOOR = 1
var SHELF = 2
var DECO = 3


func main():

	generate_chunk(1,0)

	for i in range(-1, world_size+2):
		for j in range(-1, world_size+2):
			var matrix = generate_chunk(i,j)

			for x in range(0, chunk_size):
				for y in range(0, chunk_size):
					set_cell(i * chunk_size + x, j * chunk_size + y, matrix[x][y])
			update_bitmask_region(
				Vector2(i * chunk_size - 2, j * chunk_size - 2),
				Vector2(i * chunk_size + chunk_size + 2, j * chunk_size + chunk_size + 2)
			)

func generate_chunk(cx, cy):
	rng.set_seed(seed_value ^ (cy * 123 + cx))
	if(cx < 0 or cy < 0 or cx > world_size or cy > world_size):
		return generate_wall_chunk()
	if(cx == 0 and cy == 0):
		return generate_home_chunk()
	else:
		return generate_normal_chunk(cx,cy)


func generate_wall_chunk():
	return generate_matrix(WALL)

func generate_home_chunk():
	var result = generate_matrix(FLOOR)
	generate_room_walls(result)
	return result

func generate_normal_chunk(cx,cy):
	var result = generate_matrix(FLOOR)
	generate_room_walls(result)

	var type = rng.randi_range(0,3)

	if(type == 1):
		result = generate_type_1(result)
	if(type == 2):
		result = generate_type_2(result)


	result = gen_random_deco(result)
	result = gen_random_deco(result)

	return result;


func gen_random_deco(result):

	var x = rng.randi_range(0, chunk_size-1)
	var y = rng.randi_range(0, chunk_size-1)

	if(result[x][y] == FLOOR):
		result[x][y] = DECO
	return result;

func generate_type_2(result):

	for i in range(3, chunk_size-4, 3):
		for j in range(3, chunk_size-4):
			result[j][i] = SHELF

	return result

func generate_type_1(result):

	var x = rng.randi_range(1, chunk_size/2)
	var xx = rng.randi_range(x+4, chunk_size-2)
	var y = rng.randi_range(1, chunk_size/2)
	var yy = rng.randi_range(x+4, chunk_size-2)

	for i in range(x, xx):
		for j in range(y,yy):
			result[i][j] = WALL


	var midx = int((x + xx)/2)
	var midy = int((y + yy)/2)

	var dir = rng.randi_range(0,3)

	while(midx >= 0 and midx < chunk_size and midy >= 0 and midy < chunk_size):
		result[midx][midy] = WALL
		if(dir == 0):
			midx+=1
		if(dir == 1):
			midy+=1
		if(dir == 2):
			midx-=1
		if(dir == 3):
			midy-=1

	return result;

func generate_room_walls(result):

	for i in range(chunk_size):
		result[i][chunk_size -1] = WALL
		result[chunk_size-1][i] = WALL

	var doorpos = rng.randi_range(2,chunk_size -2)
	result[doorpos][chunk_size-1] = FLOOR
	result[doorpos+1][chunk_size - 1] = FLOOR

	var doorpos2 = rng.randi_range(2,chunk_size -2)
	result[chunk_size-1][doorpos2] = FLOOR
	result[chunk_size - 1][doorpos2+1] = FLOOR

func draw_room(x, y, w, h):
	for i in range(x, x + w):
		for j in range(y, y + h):
			set_cell(i, y, 1)
			set_cell(i, y + h, 1)
			set_cell(x, j, 1)
			set_cell(x + w, j, 1)


