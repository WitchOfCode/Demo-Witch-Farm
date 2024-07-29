# Script which holds global variables/functions. Is autoloaded through Project/Autoload.
extends Node

# Specifies the layer numbers when interacting with the tilemap.
var layer_floor = 0
var layer_plot = 1
var layer_floorobj = 2
var layer_wall = 3
var layer_air = 4

# Nested Dictionary storing seed data based on ID.
var dict_seed_data = {
	1 : {
		"Name" : "Wheat",
		"Stages" : ["seed", "stub", "grown"],
		"Atlas" : [Vector2(19, 14), Vector2(20, 14), Vector2(21, 14)],
		"Timings" : [2.2, 2.1],
		"Final" : "grown"
	}
}

# String when checking for tile validity.
# Used to check if tile can be seeded.
const TILE_SEEDABLE = "seedable"
