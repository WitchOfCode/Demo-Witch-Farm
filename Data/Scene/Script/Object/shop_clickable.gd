extends Node2D

#@export player_shops: Control
#var player_shop = get_tree().get_root().get_node("res://Data/Scene/Object/Entity/Player_Character.tscn/Camera2D/ShopAndPlayerInv")
#var shop_on = false
#func _input(event):
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#if is_pixel_opaque(get_local_mouse_position()):
				#shop_on = !shop_on
				#player_shop.show()
				


func _on_button_pressed():
	pass # Replace with function body.
