extends Resource

class_name Inventory

# Signal to update the UI inventory slot.
signal update

# An array of slots which hold an item and an amount.
@export var inventory_slots : Array[InventorySlot]
@export var inventory_current_item : InventorySlot

'''Updates the current selected inventory slot by index.'''
func select_by_index(index: int):
	# If there's a slot currently selected, make it false before selecting another one.
	if inventory_current_item:
		inventory_current_item.update_selected(false)
	# Select the inventory item from the inventory slots array, then make the slot selected true.
	inventory_current_item = inventory_slots[index]
	inventory_current_item.update_selected(true)
	
'''Updates the current selected inventory slot by using another slot.'''
func select_by_slot(slot: InventorySlot):
	# If there's a slot currently selected, make it false before selecting another one.
	if inventory_current_item:
		inventory_current_item.update_selected(false)
	# Select the inventory item by using the given slot.
	inventory_current_item = slot
	inventory_current_item.update_selected(true)

'''Filters through open/filled inventory slots to insert a new item into the array.'''
func insert_item(item: InventoryItem):
	# Uses a high order function to filter out what slots have an identical resource compared to the given InventoryItem resource.
	# Also ensures that item fullfills max inventory count.
	var item_slots = inventory_slots.filter(func(slot): return is_available_slot(slot, item))
	# If there are slots in this filtered list, add their amount by one.
	if !item_slots.is_empty():
		item_slots[0].slot_amount += 1
	else:
		insert_new_item(item)
	# Emit a signal update for the UI Inventory Slots.
	update.emit()

'''Filters through open inventory slots to insert a new item into the array.'''
func insert_new_item(item: InventoryItem):
	# Filters by getting what items are null so that an item can be added.
	var empty_slots = inventory_slots.filter(func(slot): return slot.slot_item == null)
	# If there are empty slots available, add the item to the first empty slot. Set the amount by one.
	if !empty_slots.is_empty():
		empty_slots[0].slot_item = item
		empty_slots[0].slot_amount = 1
		
'''Checks the validity of an InventorySlot and a given InventoryItem.'''
func is_available_slot(slot_to_check: InventorySlot, item_to_check: InventoryItem) -> bool:
	# Gets the max amount from dictionary.
	var max_amount = Global.dict_item_data[item_to_check.item_id][Global.ITEM_MAX]
	# Checks if the slot item has an identical resource to InventoryItem, and ensures that the slot amount is not above max stack for item.
	return (slot_to_check.slot_item == item_to_check) and (slot_to_check.slot_amount < max_amount)
	
'''Checks if there are no empty slots available for the player to use.'''
func is_inventory_full():
	# If a filtered list checking for null slots returns empty, return true.
	return inventory_slots.filter(func(slot): return slot.slot_item == null).is_empty()
	
'''Removes an item by the currently selected item.
	Amount: Item amount to remove.'''
func remove_item_by_selected(amount: int):
	inventory_current_item.slot_amount -= 1
	# If the slot amount is zero, remove the item entirely.
	if (inventory_current_item.slot_amount == 0):
		delete_item(inventory_current_item)
	update.emit()
	
'''Removes an item by a given index.'''
# TODO: Remove by index.
func remove_item_by_index(index:int, amount: int):
	pass # to write.
	
'''With a given inventory slot, remove its item resource and ensure the amount is 0.'''
func delete_item(inventory_slot: InventorySlot):
	inventory_slot.slot_item = null
	inventory_slot.slot_amount = 0
	
func print_inventory():
	for slot in inventory_slots:
		if slot.slot_item:
			print(slot.slot_item.item_id)
			print(slot.slot_item.atlas_texture)
