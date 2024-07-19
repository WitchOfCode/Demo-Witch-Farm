extends Node2D

# Player's movement speed (seconds per tile)
var speed : float = .001

# Grid size (based on sprite size)
var grid_size : int = 16

# Target position for grid-based movement
var target_position : Vector2

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
	handle_input()
	move_player(delta)
	update_animation(delta)

'''Handle player input'''
func handle_input():
	if not is_moving:  # Only accept input if the player is not moving
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

'''Move the player towards the target position'''
func move_player(delta):
	if is_moving:
		var distance_to_move = speed * grid_size / delta
		position = position.move_toward(target_position, distance_to_move)

		if position == target_position:
			is_moving = false

'''Update the animation based on player movement'''
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
