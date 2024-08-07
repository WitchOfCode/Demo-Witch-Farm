extends Panel

# Readies the ItemDisplay, a Sprite2D which will hold the texture of an item.
@onready var display: Sprite2D = $DisplayCenterContainer/DisplayPanel/ItemDisplay
@onready var label : Label = $DisplayCenterContainer/DisplayPanel/ItemLabel

'''Updates the ItemDisplay with a given InventorySlot.
	Item: An InventorySlot, which holds information for the item and item amount.'''
func update(slot: InventorySlot):
	# The item that this slot holds.
	var item = slot.slot_item
	# The amount of the item above in this slot.
	var amt = slot.slot_amount
	
	# If there is no item in this slot, then there will be nothing for the item display.
	if !item:
		display.visible = false
		label.visible = false
	# Otherwise, make the display visible and set the texture to the inventory item.
	else:
		display.visible = true
		display.texture = item.atlas_texture.atlas
		update_amount(amt)
			
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
