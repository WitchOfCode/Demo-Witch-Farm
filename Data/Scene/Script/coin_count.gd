extends Control

@onready var score_label = $Coinbutton/Label2

func _process(delta):
	score_label.text = str(Global.score)
