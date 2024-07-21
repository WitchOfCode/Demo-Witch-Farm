extends CharacterBody2D

# Player's movement speed (seconds per tile)
# @export adds to Inspector properties.
@export var speed : float = 6

# Flag for checking if player going out of bounds
var out_of_bounds : bool = false

# Grid size (based on sprite size)
var grid_size : int = 16

# Target position for grid-based movement
var target_position : Vector2

# Initial position in-case player movement needs to be restricted.
var initial_position : Vector2

# Sprite node
@onready var sprite = $Sprite

# Animation variables
var direction : Vector2 = Vector2(0, 1)
var is_moving : bool = false
var animation_frame : int = 0
var animation_timer : float = 0.0
var animation_speed : float = .1005

# Load the sprite sheet
func _ready():
	sprite.texture = load("res://Resources/Character_Sprite_Sheet.png")
	sprite.region_enabled = true
	sprite.region_rect = Rect2(0, 0, 16, 16)
	target_position = position  # Initialize target position

func _process(delta):
	pass
	# move_player(delta)
	# update_animation(delta)
	
'''Process which handles consistent tasks, such as movement.'''
func _physics_process(delta):
	handle_input()
	move_and_slide()

'''Handle player input and translate it into movement.'''
func handle_input():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * (speed * grid_size)
	
	# Redundant for now, keeping code inside script just in-case it's needed later, however.
	'''if not is_moving:  # Only accept input if the player is not moving
		if not out_of_bounds: # Does not update target position if player is out of
			initial_position = position
			if Input.is_action_pressed("ui_right"):
				target_position.x += grid_size
				direction = Vector2.RIGHT
				is_moving = true
			elif Input.is_action_pressed("ui_left"):
				target_position.x -= grid_size
				direction = Vector2.LEFT
				is_moving = true
			elif Input.is_action_pressed("ui_down"):
				target_position.y += grid_size
				direction = Vector2.DOWN
				is_moving = true
			elif Input.is_action_pressed("ui_up"):
				target_position.y -= grid_size
				direction = Vector2.UP
				is_moving = true
		else: #
			target_position.x -= target_position.x
			target_position.y -= target_position.x
			out_of_bounds = false'''

'''Move the player towards the target position'''
# Redundant for now, keeping code inside script just in-case it's needed later, however.
func move_player(delta):
	if is_moving:
		var distance_to_move = speed * grid_size / delta
		position = position.move_toward(target_position, distance_to_move)

		if position == target_position:
			is_moving = false

'''Update the animation based on player movement'''
# Redundant for now, keeping code inside script just in-case it's needed later, however.
func update_animation(delta):
	if is_moving:
		animation_timer += delta
		if animation_timer > animation_speed:
			animation_timer = 0
			animation_frame = (animation_frame + 1) % 4  # 4 frames per walking animation

		match direction:
			Vector2.RIGHT:
				sprite.region_rect = Rect2(animation_frame * 16, 4 * 16, 16, 16)
			Vector2.LEFT:
				sprite.region_rect = Rect2(animation_frame * 16, 2 * 16, 16, 16)
			Vector2.UP:
				sprite.region_rect = Rect2(animation_frame * 16, 3 * 16, 16, 16)
			Vector2.DOWN:
				sprite.region_rect = Rect2(animation_frame * 16, 1 * 16, 16, 16)
	else:
		match direction:
			Vector2.RIGHT:
				sprite.region_rect = Rect2(3 * 16, 0, 16, 16)
			Vector2.LEFT:
				sprite.region_rect = Rect2(1 * 16, 0, 16, 16)
			Vector2.UP:
				sprite.region_rect = Rect2(2 * 16, 0, 16, 16)
			Vector2.DOWN:
				sprite.region_rect = Rect2(0 * 16, 0, 16, 16)

	
'''Checks to see if the player has entered another object.'''
func _on_area_2d_area_entered(area):
	# Checks to make sure player is not in out of bounds Collision Box.
	if area.is_in_group("outer_bounds"):
		out_of_bounds = true
