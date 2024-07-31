extends Node2D

# Last recorded position of the mouse.
var record_mouse_pos : Vector2
# Position of the mouse translated into a tile map position
var record_tile_pos : Vector2i

# Variables and their specified type.
# The tile map to be set when the script first starts.
var scene_tile_map : TileMap

# The TileSet ID that is used when selecting a TileMap.
var tile_set_id : int = 0

# New variable to hold the player instance
var player

'''Ready loads when the script first loads.'''
func _ready():
	# Initializes the child nodes to be used.
	scene_tile_map = get_node("TestTileMap")
	
	# Instance and add the player to the scene
	# player = load("res://Data/Scene/Object/Player_Character.tscn").instantiate()
	# add_child(player)
	# player.position = scene_tile_map.map_to_world(Vector2(2, 2))  # Adjust initial position
	
'''Process loads every couple of frames.'''
func _process(delta):
	pass

'''When input is registered in Main, run through the different inputs.'''
func _input(event):
	# Uses the Input singleton to check the action done.
	
	# Checks the action when a left click has occured.
	if Input.is_action_just_pressed("on_left_click"):
		# Update record variable
		update_positions()
		# Seeds the tile after positions have been updated.
		seed_tile()
		
'''When called, update the positions of the record variables (mouse position, tilemap position, etc.).'''
func update_positions():
	record_mouse_pos = get_global_mouse_position()
	record_tile_pos = scene_tile_map.local_to_map(record_mouse_pos)
	
'''Seeds a tile based on the current mouse records.'''
func seed_tile():
	# Gets the tile data from mouse position (for checking)
	var tile_data : TileData = scene_tile_map.get_cell_tile_data(Global.layer_plot, record_tile_pos)
	
	# Ensures that tile_data retrieved is valid.
	if tile_data:
		# Using the Custom Data Layer boolean, check to make sure tile is seedable.
		if tile_data.get_custom_data(Global.TILE_SEEDABLE):
			# Then set the cell to the seed.
			grow_seed(record_tile_pos, 1, 0)
			
'''Grows a seed based on the data from the item dictionary.
	Tile Position: Used to find the tile to modify.
	Item ID: Used to index the item data dictionary.
	Growth Level: Used to identify what stage seed is currently in.
Currently recurses over tile until it is at the final stage.'''
func grow_seed(tile_position, item_id, growth_level):
	# Variables from dictionary:
	# Actual item data
	var item_value = Global.dict_seed_data[item_id]
	# Stage that seed is currently in
	var item_stage = item_value["Stages"][growth_level]
	# Atlas coord to replace the current tile.
	var item_atlas_coord = item_value["Atlas"][growth_level]
	
	# Sets the selected tile with the seed's atlas coord.
	scene_tile_map.set_cell(Global.layer_floorobj, tile_position, tile_set_id, item_atlas_coord)
	# Ensures that the current stage isn't the final one.
	if item_stage == item_value["Final"]:
		return
	var item_timing = item_value["Timings"][growth_level]
	
	# Creates a timer in the tree, and awaits its timeout using the current item timing.
	await get_tree().create_timer(item_timing).timeout
	# Recurses, adding a growth level each loop.
	grow_seed(tile_position, item_id, growth_level + 1)
	
