extends Control

# Preloads the inventory class resource for player inventory.
@onready var inv: Inventory = preload("res://Data/Items/Resources/player_inventory.tres")
# Gets the GridContainer's children (the slots to reference and use).
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
# Gets the description slot.
@onready var desc_box : NinePatchRect = $UiDescriptionSlot

@onready var shop_inv = $UIShopInventory

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

'''Given a slot, call this inventorys select by slot function.'''
func call_selected(slot: InventorySlot):
	inv.select_by_slot(slot)
	desc_box.update_by_slot(slot)

func _on_button_2_pressed():
	if inv.inventory_current_item.slot_amount > 0:
		var item_id = inv.inventory_current_item.slot_item.item_id
		Global.score += Global.dict_item_data[item_id][Global.ITEM_SELL]
		print(Global.score)
		inv.remove_item_by_selected(1)


func _on_button_pressed():
	pass # Replace with function body.
