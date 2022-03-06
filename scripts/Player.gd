extends KinematicBody2D

var velocity = Vector2()

export var speed = 100 # How fast the player will move (pixels/sec).
var screen_size
var touching_on = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
func _physics_process(delta):
	move()

func move():	
	if not touching_on:
		velocity = Vector2()
	
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
	if Input.is_action_pressed("move_down"):
		velocity.y = speed
	if Input.is_action_pressed("move_up"):
		velocity.y = -speed
		
	if velocity.length() >= 0:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	if velocity.x != 0:
		$AnimatedSprite.animation = "side"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y > 0:
		$AnimatedSprite.animation = "down"
	elif velocity.y < 0:
		$AnimatedSprite.animation = "up"
		
		
	if(velocity.x != 0 or velocity.y != 0):
		$Light2D.rotation = atan2(velocity.y, velocity.x)
	
	
	
	

	move_and_slide(velocity, Vector2(0, -1))

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_Analog_analog_move(direction):
	var dir = atan2(direction.y, direction.x)
	
	if(direction.x > 0.5):
		velocity.x = speed
	if(direction.x < -0.5):
		velocity.x = -speed
	if(direction.y > 0.5):
		velocity.y = speed
	if(direction.y < -0.5):
		velocity.y = -speed
	
	print(str(direction) + " " + str(velocity))
	pass # Replace with function body.


func _on_Analog_analog_touch(touching):
	touching_on = touching
	pass # Replace with function body.
