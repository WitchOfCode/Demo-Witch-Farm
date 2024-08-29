extends Control

@onready var score_label = $Coinbutton/Label2
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	score_label.text = str(Global.score)

