extends Node2D

# The seed ID that this script uses.
var crop_seed_id : int
# The current stage the crop is in.
var current_stage : int
# The dictionary that will be used for the crop's data.
var crop_data : Dictionary
# Boolean for outside variables, in-case a crop needs to stop growing.
# False by default.
@export var is_frozen : bool = false

# The SpriteFrames to use when animating a crop.
@onready var crop_sprite
# The timer to use when animating a crop.
@onready var crop_timer

func _ready():
	pass

'''When initializing a crop, set the variables necessary for determining the crop.
	Seed ID: The seed ID to be used for growing.
	Set Stage: The Stage number used to determine how grown the crop is.'''
func set_seed(seed_id: int, set_stage: int = 1):
	# Sets the scripts' variables.
	crop_seed_id = seed_id
	current_stage = set_stage
	crop_data = Global.dict_seed_data[crop_seed_id]
	
	# Sets up the sprite.
	crop_sprite = $GrowthSprite
	crop_sprite.play(crop_data[Global.SEED_NAME])
	# Sets up timer.
	crop_timer = $GrowthTimer

'''If the crop has reached the final stage, it is done growing. Returns a boolean.'''
func is_grown() -> bool:
	return true if current_stage == crop_data[Global.SEED_STAGES] else false

'''Grows a seed recursively and updates by stage.'''
func grow_seed():
	# Updates the sprite and timer.
	update_by_stage()
	
	# Does not recurse if the plant has been grown, or if it is frozen.
	if not is_grown() and not is_frozen:
		# Recurse by restarting the GrowthTimer.
		if crop_timer.is_stopped(): crop_timer.start()

'''Update the sprite/timer by current stage.'''
func update_by_stage():
	# Sets the current frame (minus 1 for index)
	crop_sprite.frame = current_stage - 1
	# Sets the timer to the stage's wait time.
	crop_timer.wait_time = crop_data[Global.SEED_TIMINGS][current_stage - 1]

'''When GrowthTimer times out, advance stage and call grow_seed function again.'''
func _on_growth_timer_timeout():
	# Recurses, progressing through the next stage.
	current_stage += 1
	grow_seed()
