extends Control

@onready var main = $"../../../"
#var save_path = "user"

func _on_resume_pressed():
	main.pauseMenu()


func _on_quit_pressed():
	get_tree().quit()
