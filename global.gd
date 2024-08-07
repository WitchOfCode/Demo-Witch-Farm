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
const SEED_YIELD: String = "Yield" # The item ID used when a crop is harvested.
const SEED_YIELD_AMT : String = "Yield_Amt" # The amount of items yielded when harvested.

# Nested Dictionary storing seed data based on ID.
var dict_seed_data = {
	0 : {
		SEED_NAME : "grow_wheat",
		SEED_STAGES : 3,
		SEED_TIMINGS : [0.2, 0.1, 1],
		SEED_YIELD : 0,
		SEED_YIELD_AMT : 3
	}
}

# Specifies the key names used for the dictionary of item data.
const ITEM_IDENTIFIER : String = "Identifier" # Identifier used for sprite and indexing.
const ITEM_NAME : String = "Name" # Name of the item sprite
const ITEM_DESC : String = "Description"
const ITEM_PRICE : String = "Price" # Price of the item, in-case its sold. If null, it's not supposed to be a sold item.
const ITEM_SELL : String = "Sell" # How much an item sells for. If null, it's not supposed to be sellable.

# Nested Dictionary storing item data based on ID.
var dict_item_data = {
	0 : {
		ITEM_IDENTIFIER : "item_seed_wheat",
		ITEM_NAME : "Wheat Seeds",
		ITEM_DESC : "Seeds to grow some wheat!",
		ITEM_PRICE : 2.25,
		ITEM_SELL : null
	},
	1 : {
		ITEM_IDENTIFIER : "item_wheat",
		ITEM_NAME : "Wheat Stalks",
		ITEM_DESC : "Stalks grown and harvested.",
		ITEM_PRICE : 3.50,
		ITEM_SELL : 3.25
	}
}

# Strings when checking for tile validity.
# Used to check if tile can be seeded.
const IS_SEEDABLE_TILE : String = "seedable"
# Used to check if tile is seeded.
const IS_SEEDED_TILE : String = "seeded"

# Path names
const ITEM_RESOURCE_PATH : String = "res://Data/Items/Resources/"

# File Extensions.
const PREFIX_RESOURCE : String = ".tres"
