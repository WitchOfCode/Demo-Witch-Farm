extends Control

# Preloads the inventory class resource for player inventory.
@onready var inv: Inventory = preload("res://Data/Items/Resources/shop_inventory.tres")
# Gets the GridContainer's children (the slots to reference and use).
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
# Gets the description slot.
@onready var desc_box : NinePatchRect = $UiDescriptionSlot

var is_open : bool = false

'''When the control is initialized, update slots and close the menu.'''
func _ready():
	# Attach inventory signal to the update slots fucntion.
	inv.update.connect(update_slots)
	# Update the slots and close.
	initialize_slots()
	close()

'''Ties each UI Inventory Slot by its Inventory Slot counterpart.'''
func initialize_slots():
	# Keeps a running index
	var index = 0
	# Iterates through each slot to tie a variable to.
	for ui_slot in slots:
		ui_slot.update_by_slot(inv.inventory_slots[index])
		ui_slot.slot_clicked.connect(call_selected.bind(ui_slot.slot))
		index += 1

'''Update the ui_inventory_slots accordingly.'''
func update_slots(): 
	for ui_slot in slots:
		ui_slot.update()
	
'''When the user inputs soemthing, do the inputs done here.'''
func _input(_event):
	# If the player presses something from the Input Map, do this:
	# Open the inventory (press Q)
	if Input.is_action_just_pressed("Open Inventory"): #TODO if shop is clicked the 
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

'''Given a slot, call this inventorys select by slot function.'''
func call_selected(slot: InventorySlot):
	inv.select_by_slot(slot)
	desc_box.update_by_slot(slot)

#func close_inventory():
	#if is_open:
		#close()
	#else:
		#open()

