# Script which holds global variables/functions. Is autoloaded through Project/Autoload.
extends Node

# Specifies the layer numbers when interacting with the tilemap.
var layer_floor = 0
var layer_plot = 1
var layer_floorobj = 2
var layer_wall = 3
var layer_air = 4

# Specifies the key names used for the dictionary of seed data.
const SEED_NAME : String = "Name" # Name of the crop growth sprite.
const SEED_STAGES : String = "Stages" # How many stages there are in this crop.
const SEED_TIMINGS : String = "Timings" # Timings of when the crop goes into the next stage.

# Nested Dictionary storing seed data based on ID.
var dict_seed_data = {
	1 : {
		SEED_NAME : "grow_wheat",
		SEED_STAGES : 3,
		SEED_TIMINGS : [2.2, 2.1, 1]
	}
}

# Strings when checking for tile validity.
# Used to check if tile can be seeded.
const IS_SEEDABLE_TILE = "seedable"
# Used to check if tile is seeded.
const IS_SEEDED_TILE = "seeded"
