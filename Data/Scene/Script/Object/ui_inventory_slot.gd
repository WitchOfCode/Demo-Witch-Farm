extends Panel

# Ties the inventory slot class to this node.
@export var slot : InventorySlot

# Readies the ItemDisplay, a Sprite2D which will hold the texture of an item.
@onready var display : Sprite2D = $DisplayCenterContainer/DisplayPanel/ItemDisplay
@onready var label : Label = $DisplayCenterContainer/DisplayPanel/ItemLabel
# Slots which dictate when an item is selected.
@onready var selected_slot : Sprite2D = $SelectedSlot
@onready var unselected_slot : Sprite2D = $UnselectedSlot

# Variable to check if the sprite can be dragged.
var is_draggable : bool = false

# When the slot has been clicked, make a signal for inventory to catch it.
signal slot_clicked

'''Updates the ItemDisplay with a given InventorySlot.
	New Slot: A new InventorySlot to initalize in this node.'''
func update_by_slot(new_slot: InventorySlot):
	slot = new_slot
	slot.selected.connect(update_selected)
	update()

'''Updates the ItemDisplay by inventory slot.'''
func update():
	# The item that this slot holds.
	var item = slot.slot_item
	# The amount of the item above in this slot.
	var amt = slot.slot_amount
	
	# If there is no item in this slot, then there will be nothing for the item display.
	if !item:
		display.texture = null
		label.visible = false
	# Otherwise, make the display visible and set the texture to the inventory item.
	else:
		display.texture = item.atlas_texture.atlas
		display.region_rect = item.atlas_texture.region
		update_amount(amt)
	update_selected()
		
'''Updates the UI if the slot is currently being selected.'''
func update_selected():
	# Slot is currently selected.
	if slot.slot_selected:
		selected_slot.visible  = true
		unselected_slot.visible = false
	# Slot is currently unselected.
	else:
		selected_slot.visible  = false
		unselected_slot.visible = true
			
''' Given an amount, update the item amount label.
	 Amount: Item count in a given slot.'''
func update_amount(amount: int):
	# If the item amount is no greater than 1, don't display the label.
	if amount <= 1:
		label.visible = false
	# Otherwise, display it and update the count.
	else:
		label.visible = true
		label.text = str(amount)

'''When the button on slot has been clicked, emit signal.'''
func _on_button_pressed():
	slot_clicked.emit()
