extends Node2D

# Last recorded position of the mouse.
var record_mouse_pos : Vector2
# Position of the mouse translated into a tile map position
var record_tile_pos : Vector2i

# Variables and their specified type.
# The tile map to be set when the script first starts.
var scene_tile_map : TileMap
# The name of the tile map node.
@export var tile_map_name : String

# The TileSet ID that is used when selecting a TileMap.
var tile_set_id : int = 0

# New variable to hold the player instance
var player

'''Ready loads when the script first loads.'''
func _ready():
	# Initializes the child nodes to be used.
	scene_tile_map = get_node(tile_map_name)
	
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
	var item_stage = item_value[Global.SEED_STAGES][growth_level]
	# Atlas coord to replace the current tile.
	var item_atlas_coord = item_value[Global.SEED_TILESET_ATLAS][growth_level]
	# Tileset ID to use when setting cell.
	var item_tile_set_id = item_value[Global.SEED_TILESET_ID]
	
	# Sets the selected tile with the seed's atlas coord.
	scene_tile_map.set_cell(Global.layer_floorobj, tile_position, item_tile_set_id, item_atlas_coord)
	# Ensures that the current stage isn't the final one.
	if item_stage == item_value[Global.SEED_STAGES_FINAL]:
		return
	var item_timing = item_value[Global.SEED_TIMINGS][growth_level]
	
	# Creates a timer in the tree, and awaits its timeout using the current item timing.
	await get_tree().create_timer(item_timing).timeout
	# Recurses, adding a growth level each loop.
	grow_seed(tile_position, item_id, growth_level + 1)
	
