extends Node2D

# Last recorded position of the mouse.
var record_mouse_pos : Vector2
# Position of the mouse translated into a tile map position
var record_tile_pos : Vector2i

# Variables and their specified type.
# The tile map to be set when the script first starts.
var scene_tile_map : TileMap
# Crop scene to spawn in different objects.
var scene_crop_16x64 : PackedScene
# The name of the tile map node.
@export var tile_map_name : String

# Tthe TileSet ID that is used when selecting a TileMap.
var tile_set_id : int = 0
@onready var pause_menu = $PlayerCharacter/Camera2D/PauseMenu
var paused: bool = false
# Nnew variable to hold the player instance
@onready var player : CharacterBody2D = $PlayerCharacter

'''Ready loads when the script first loads.'''
func _ready():
	# Initializes the child nodes to be used.
	scene_tile_map = get_node(tile_map_name)
	# Initializes the crop plot scene to this scene.
	scene_crop_16x64 = load("res://Data/Scene/Object/Environment/env_crop_16x64.tscn")
	
'''Process loads every couple of frames.'''
func _process(_delta):
	pass

'''When input is registered in Main, run through the different inputs.'''
func _input(_event):
	# Uses the Input singleton to check the action done.
	
	# Checks the action when a left click has occured.
	if Input.is_action_just_pressed("on_left_click"):
		# Update record variable
		update_positions()
		# Seeds the tile after positions have been updated.
		seed_tile()
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.hide()	
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	paused = !paused
	
'''When called, update the positions of the record variables (mouse position, tilemap position, etc.).'''
func update_positions():
	record_mouse_pos = get_global_mouse_position()
	record_tile_pos = scene_tile_map.local_to_map(record_mouse_pos)
	
'''Checks to see if a tile is able to be seeded.
	Plot Data: TileData to check if a tile can be seeded or not.
	Seed Data: TileData to check if a tile has been seeded already.'''
func check_tile_validity(plot_data: TileData, seed_data : TileData) -> bool:
	# Ensures that plot_data retrieved is valid.
	if plot_data:
		# Checks if plot tile is seedable.
		var is_tile_seedable : bool = plot_data.get_custom_data(Global.IS_SEEDABLE_TILE)
		# Checks to see if seed tile is valid, and if it is already seeded.
		var is_tile_seeded : bool = seed_data.get_custom_data(Global.IS_SEEDED_TILE) if seed_data else false
		
		# If tile is seedable and is already not seeded, return true.
		if is_tile_seedable and not is_tile_seeded:
			return true
		# Else it cannot have a seed grown there.
		return false
	# Else a non-valid tile cannot be seeded.
	return false
		
	
'''Seeds a tile based on the current mouse records.'''
func seed_tile():
	# Gets the tile data from mouse position (for checking)
	var plot_tile_data : TileData = scene_tile_map.get_cell_tile_data(Global.layer_plot, record_tile_pos)
	var seed_tile_data : TileData = scene_tile_map.get_cell_tile_data(Global.layer_floorobj, record_tile_pos)
	
	# Checks tile validity. If tile is available, grow a seed.
	if check_tile_validity(plot_tile_data, seed_tile_data):
		# Selects the currently selected item in player's inventory.
		var item_to_plant = remove_item_as_seed()
		if item_to_plant != -1:
			# Sets the plot to a plot tile.
			scene_tile_map.set_cell(Global.layer_plot, record_tile_pos, 0, Vector2i(13, 14))
			# Instances a new crop
			create_crop_instance(item_to_plant)
			
'''Removes an item from the inventory after checking the currently selected slot and item are valid.
	Returns an items plant ID, if it has one. Otherwise, it returns -1.'''
func remove_item_as_seed() -> int:
	# Gets current slot in player's inventory and ensures its valid.
	var slot = player.inv.inventory_current_item
	if slot:
		# Gets item, checks if its valid.
		var item = slot.slot_item
		if item:
			# Checks the item's plant ID.
			var seed = Global.dict_item_data[item.item_id][Global.ITEM_PLANT]
			if seed != null:
				player.inv.remove_item_by_selected(1)
				# Returns the plant ID.
				return seed
	# If neither slot or item/item plant are valid, return null.
	return -1
		
'''Create a new crop instance.
	Seed ID: The seed from dict_seed_data to use.'''
func create_crop_instance(seed_id: int):
	# Instantiate scene and set its variables.
	var itm_instance = scene_crop_16x64.instantiate()
	
	# Add new child to scene.
	add_child(itm_instance)
	# Set its variables.
	itm_instance.global_position = scene_tile_map.map_to_local(record_tile_pos)
	itm_instance.set_seed(seed_id, player)
	itm_instance.grow_seed()
	# Connects the harvested crop signal to the destroy function.
	itm_instance.harvested_crop.connect(destroy_crop_instance.bind(itm_instance))
	
'''Given the crop instance, revert the tile its on to a dirt tile and destroy the object.
	Crop Instance: The crop instance to destroy.'''
func destroy_crop_instance(crop_instance):
	var crop_position = scene_tile_map.local_to_map(crop_instance.global_position)
	scene_tile_map.set_cell(Global.layer_plot, record_tile_pos, 0, Vector2i(5, 3))
	
	crop_instance.queue_free()
