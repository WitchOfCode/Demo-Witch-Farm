extends Resource

class_name Inventory

# Signal to update the UI inventory slot.
signal update

# An array of slots which hold an item and an amount.
@export var inventory_slots : Array[InventorySlot]

'''Filters through open/filled inventory slots to insert a new item into the array.'''
func insert_item(item: InventoryItem):
	# Uses a high order function to filter out what slots have an identical resource compared to the given InventoryItem resource.
	var item_slots = inventory_slots.filter(func(slot): return slot.slot_item == item)
	# If there are slots in this filtered list, add their amount by one.
	if !item_slots.is_empty():
		item_slots[0].slot_amount += 1
	else:
		# Filters by getting what items are null so that an item can be added.
		var empty_slots = inventory_slots.filter(func(slot): return slot.slot_item == null)
		# If there are empty slots available, add the item to the first empty slot. Set the amount by one.
		if !empty_slots.is_empty():
			empty_slots[0].slot_item = item
			empty_slots[0].slot_amount = 1
	# Emit a signal update for the UI Inventory Slots.
	update.emit()
