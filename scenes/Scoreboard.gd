extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_scores(scores):
	print(scores)
	$Score.text = str(scores[0].name, ": ", scores[0].score)
	$Score2.text = str(scores[1].name, ": ", scores[1].score)
	$Score3.text = str(scores[2].name, ": ", scores[2].score)
