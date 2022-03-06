extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_scores(scores):
	print(scores)
	$Score.text = str(scores[0])
	$Score2.text = str(scores[1])
	$Score3.text = str(scores[2])
