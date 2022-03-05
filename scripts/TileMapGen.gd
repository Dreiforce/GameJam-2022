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

	main()
	update_dirty_quadrants()
	update_bitmask_region()


##### INSERT GENERATOR HERE

var seed_value = 100
var chunk_size = 32
var WALL = 0
var FLOOR = 1
var EMPTY = 2


func main():

	for i in range(-1, 5):
		for j in range(-1, 5):
			var matrix = generate_chunk(i,j)

			print(matrix[0][0])
			for x in range(0, chunk_size):
				for y in range(0, chunk_size):
					set_cell(i * chunk_size + x, j * chunk_size + y, matrix[x][y])
			update_bitmask_region(
				Vector2(i * chunk_size - 1,j * chunk_size - 1), 
				Vector2(i * chunk_size + chunk_size + 1,j * chunk_size + chunk_size + 1)
				)

func generate_chunk(cx, cy):
	rng.set_seed(seed_value ^ (cy * 123 + cx))

	if(cx < 0 or cy < 0):
		return generate_wall_chunk()
	elif(cx == 0 and cy == 0):
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
