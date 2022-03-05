extends TileMap

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	rng.set_seed(100)
#	for i in range(-50, 50):
#		for j in range(-50, 100):
#			var cell = 2
#			if(rng.randf() < 0.1):
#				cell = rng.randi_range(3,5)
#			set_cell(i,j,cell)
#
#	for i in range (10):
#		var x = rng.randi_range(-35, 35)
#		var y = rng.randi_range(20, 200)
#		var sizex = rng.randi_range(10,20)
#		var sizey = sizex * rng.randi_range(1,3) / 4
#
#		draw_room(x,y,sizex,sizey)

func draw_room(x,y,w,h):
	for i in range(x, x+w):
		for j in range(y, y+h):
			set_cell(i,y,1)
			set_cell(i,y+h,1)
			set_cell(x,j,1)
			set_cell(x+w,j,1)
