extends Control


@onready var credits_menu = $Credits_menu
@onready var play_button = $Play
@onready var credits_button = $Credits
@onready var title = $Label

var credits_on: bool = false

func _on_credits_pressed():
	if credits_on:
		credits_menu.hide()	
		play_button.show()
		credits_button.show()
		title.show()
	else:
		credits_menu.show()
		play_button.hide()
		credits_button.hide()
		title.hide()
	credits_on = !credits_on
	
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Data/Scene/Object/Environment/test_area.tscn")
	
func _on_texture_button_pressed():
	_on_credits_pressed()
