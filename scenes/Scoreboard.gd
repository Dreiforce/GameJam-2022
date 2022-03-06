extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_scores(scores):
	$Name.text = scores[0].name + ":"
	$Name2.text = scores[1].name + ":"
	$Name3.text = scores[2].name + ":"
	
	$Score.text = str(scores[0].score)
	$Score2.text = str(scores[1].score)
	$Score3.text = str(scores[2].score)
