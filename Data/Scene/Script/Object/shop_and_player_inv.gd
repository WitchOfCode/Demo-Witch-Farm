#extends Control
#
#@onready var player_inventory : Control = $UIPlayerInventory
#@onready var shop_inventory : Control = $UIShopInventory
#
#var is_open = false
#
#func _input(_event):
	## If the player presses something from the Input Map, do this:
	## Open the inventory (press Q)
	#if Input.is_action_just_pressed("Open Inventory"): #TODO if shop is clicked then it opens
		#if is_open:
			#close()
		#else:
			#open()
			#
#
#'''Opens the inventory by making the panel visible, and setting is_open to true.'''
#func open():
	#visible = true
	#is_open = true
	#player_inventory.close_inventory()
	#shop_inventory.close_inventory()
	#
#'''Closes the inventory by making the panel invisible, and setting is_open to false.'''
#func close():
	#visible = false
	#is_open = false
	#player_inventory.close_inventory()
	#shop_inventory.close_inventory()
