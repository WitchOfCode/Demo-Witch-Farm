# Script which holds global variables/functions. Is autoloaded through Project/Autoload.
extends Node

# Specifies the layer numbers when interacting with the tilemap.
var layer_floor = 0
var layer_plot = 1
var layer_floorobj = 2
var layer_wall = 3
var layer_air = 4

# Specifies the key names used for the dictionary of seed data.
const SEED_NAME : String = "Name" # Name of the crop.
const SEED_STAGES : String = "Stages" # Stage names that identify how much a crop has grown.
const SEED_STAGES_FINAL : String = "Final" # Stage name to end the growth of crop.
const SEED_TIMINGS : String = "Timings" # Timings of when the crop goes into the next stage.
const SEED_TILESET_ATLAS : String = "Atlas" # Atlas Coordinates used to define seed's sprite.
const SEED_TILESET_ID : String = "T_ID" # Tile Set ID used to define the resource picture.

# Nested Dictionary storing seed data based on ID.
var dict_seed_data = {
	1 : {
		SEED_NAME : "Wheat",
		SEED_STAGES : ["seed", "stub", "grown"],
		SEED_TILESET_ATLAS : [Vector2(1, 0), Vector2(2, 0), Vector2(3, 0)],
		SEED_TIMINGS : [2.2, 2.1],
		SEED_STAGES_FINAL : "grown",
		SEED_TILESET_ID : 1
	}
}

# Strings when checking for tile validity.
# Used to check if tile can be seeded.
const IS_SEEDABLE_TILE = "seedable"
# Used to check if tile is seeded.
const IS_SEEDED_TILE = "seeded"
