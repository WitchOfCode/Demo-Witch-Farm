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
# Desired tile to place when setting a TileMap cell.
# (Uses Atlas Coords, which are basically coordinates on the TileSet).
var tile_set_atlas_coord : Vector2 = Vector2(5, 3)

'''Ready loads when the script first loads.'''
func _ready():
	# Initializes the child nodes to be used.
	scene_tile_map = get_node("TestTileMap")
	
'''Process loads every couple of frames.'''
func _process(delta):
	pass

'''When input is registered in Main, run through the different inputs.'''
func _input(event):
	# Uses the Input singleton to check the action done.
	
	# Checks the action when a left click has occured.
	if Input.is_action_just_pressed("on_left_click"):
		update_positions()
		scene_tile_map.set_cell(Global.layer_floor, record_tile_pos, tile_set_id, tile_set_atlas_coord)
		
'''When called, update the positions of the record variables (mouse position, tilemap position, etc.).'''
func update_positions():
	record_mouse_pos = get_global_mouse_position()
	record_tile_pos = scene_tile_map.local_to_map(record_mouse_pos)
