extends Control

# Preloads the inventory class resource for player inventory.
@onready var inv: Inventory = preload("res://Data/Items/Resources/player_inventory.tres")
# Gets the GridContainer's children (the slots to reference and use).
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
# Gets the description slot.
@onready var desc_box : NinePatchRect = $UiDescriptionSlot

@onready var shop_inv = $UIShopInventory

# The error validation box when the player makes an invalid request.
@onready var error_rect : NinePatchRect = $ErrorPatch
@onready var error_label : Label = $ErrorPatch/ErrorLabel

var is_open : bool = false

'''When the control is initialized, update slots and close the menu.'''
func _ready():
	# Attach inventory signal to the update slots fucntion.
	inv.update.connect(update_slots)
	# Update the slots and close.
	initialize_slots()
	close()
	error_rect.visible = false

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
	if Input.is_action_just_pressed("Open Inventory"):
		if is_open:
			close()
		else:
			open()
	
'''Opens the inventory by making the panel visible, and setting is_open to true. Turns off shop inventory.'''
func open():
	visible = true
	is_open = true
	shop_inv.close()

'''Opens the inventory by making the panel visible, and setting is_open to true. Turns on shop inventory.'''
func open_shop():
	visible = true
	is_open = true	#TODO: should we turn this off
	shop_inv.open()
	
'''Closes the inventory by making the panel invisible, and setting is_open to false.'''
func close():
	visible = false
	is_open = false
	hide_error_box()

'''Given a slot, call this inventorys select by slot function.'''
func call_selected(slot: InventorySlot):
	inv.select_by_slot(slot)
	desc_box.update_by_slot(slot)

'''The sell button on the player inventory is pressed.'''
func _on_button_2_pressed():
	# Ensure that the current inventory slot isn't filled
	if inv.inventory_current_item.slot_amount > 0:
		# Get the item ID
		var item_id = inv.inventory_current_item.slot_item.item_id
		# Get the actual sell price of the item.
		var item_sell = Global.dict_item_data[item_id][Global.ITEM_SELL]
		# If the sell price is valid, add it to the player's current money and remove the current item.
		if item_sell:
			Global.score += item_sell
			inv.remove_item_by_selected(1)
		# Otherwise, bring up an error message.
		else:
			show_error_box("These items are not sellable!")
	# Otherwise, bring up an error message.
	else:
		show_error_box("No items to sell!")

'''The buy button on the shop is pressed.'''
func _on_button_pressed():
	# Gets the current shop slot.
	var shop_current = shop_inv.inv.inventory_current_item.slot_item
	# Makes sure that there is an inventory item to select.
	if shop_current:
		# Gets the item's details from dictionary.
		var item_price = Global.dict_item_data[shop_current.item_id][Global.ITEM_PRICE]
		# If ther player can pay for it, subtract money and add item to inventory.
		if Global.score >= item_price:
			inv.insert_item(shop_current)
			Global.score -= item_price
		else:
			show_error_box("Not enough money.")
	# Otherwise, the slot is unavailable.
	else:
		show_error_box("This slot currently has no items stocked.")
	
'''Given an error message, display the error box when an invalid request is made.'''
func show_error_box(error_msg: String):
	# Show the error rect and message.
	error_rect.visible = true
	error_label.text = error_msg
	
'''Hide the error box.'''
func hide_error_box():
	error_rect.visible = false
	error_label.text = ""
