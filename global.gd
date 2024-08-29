# Script which holds global variables/functions. Is autoloaded through Project/Autoload.
extends Node

# Global variable for checking if an object is currently being dragged.
var is_mouse_dragging_obj : bool = false

# Specifies the layer numbers when interacting with the tilemap.
const layer_floor : int = 0
const layer_plot : int = 1
const layer_floorobj : int = 2
const layer_wall : int = 3
const layer_air : int = 4

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
		SEED_YIELD : 1,
		SEED_YIELD_AMT : 1
	}
}

# Specifies the key names used for the dictionary of item data.
const ITEM_IDENTIFIER : String = "Identifier" # Identifier used for sprite and indexing.
const ITEM_NAME : String = "Name" # Name of the item sprite
const ITEM_DESC : String = "Description"
const ITEM_PRICE : String = "Price" # Price of the item, in-case its sold. If null, it's not supposed to be a sold item.
const ITEM_SELL : String = "Sell" # How much an item sells for. If null, it's not supposed to be sellable.
const ITEM_MAX : String = "Max Amount" # The max stack amount for an item.
const ITEM_PLANT : String = "Plant" # What Seed ID this item plants.

# Nested Dictionary storing item data based on ID.
var dict_item_data = {
	0 : {
		ITEM_IDENTIFIER : "item_seed_wheat",
		ITEM_NAME : "Wheat Seeds",
		ITEM_DESC : "Seeds to grow some wheat!",
		ITEM_PRICE : 2.25,
		ITEM_SELL : null,
		ITEM_MAX : 20,
		ITEM_PLANT: 0
	},
	1 : {
		ITEM_IDENTIFIER : "item_wheat",
		ITEM_NAME : "Wheat Stalks",
		ITEM_DESC : "Stalks grown and harvested.",
		ITEM_PRICE : 3.25,
		ITEM_SELL : 3.50,
		ITEM_MAX : 3,
		ITEM_PLANT : null
	},
	2 : {
		ITEM_IDENTIFIER : "item_seed_dark_wheat",
		ITEM_NAME : "Dark Wheat Seeds",
		ITEM_DESC : "Magic versions of wheat that grow extremely quickly.",
		ITEM_PRICE : 2.25,
		ITEM_SELL : null,
		ITEM_MAX : 20,
		ITEM_PLANT : null
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

var score: float = 0
