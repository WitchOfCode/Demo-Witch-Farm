extends Control

# Preloads the inventory class resource for player inventory.
@onready var inv: Inventory = preload("res://Data/Items/Resources/player_inventory.tres")
# Gets the GridContainer's children (the slots to reference and use).
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open : bool = false

'''When the control is initialized, update slots and close the menu.'''
func _ready():
	# Attach inventory signal to the update slots fucntion.
	inv.update.connect(update_slots)
	# Update the slots and close.
	update_slots()
	close()

func update_slots():
	for i in range(min(inv.inventory_slots.size(), slots.size())):
		slots[i].update(inv.inventory_slots[i])
	
'''When the user inputs soemthing, do the inputs done here.'''
func _input(_event):
	# If the player presses something from the Input Map, do this:
	# Open the inventory (press Q)
	if Input.is_action_just_pressed("Open Inventory"):
		if is_open:
			close()
		else:
			open()
	
'''Opens the inventory by making the panel visible, and setting is_open to true.'''
func open():
	visible = true
	is_open = true
	
'''Closes the inventory by making the panel invisible, and setting is_open to false.'''
func close():
	visible = false
	is_open = false
