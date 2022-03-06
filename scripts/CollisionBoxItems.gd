extends StaticBody2D

var tex = preload("res://art/collision_objects/Table_horizontal.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	var rect = RectangleShape2D.new()
	rect.extents = Vector2(29,12)
	var coll = CollisionShape2D.new()
	coll.shape = rect
	coll.position = Vector2(0,-3)
	coll.scale = Vector2(1,1)
	coll.visible = true
	add_child(coll)
	var sprite = Sprite.new()
	sprite.texture = tex
	add_child(sprite)
	
func test_position(tilemap,x,y):
	for i in range(0, 15):
		for j in range(0, 10):
			if(tilemap.get_cell(x+i, y+j) != tilemap.FLOOR):
				return false
	return true
