extends Resource

class_name InventorySlot

# The Inventory item held in this slot.
@export var slot_item : InventoryItem
# The item amount held in this slot.
@export var slot_amount : int
# Checks if the slot is currently being selected.
@export var slot_selected : bool = false

signal selected

'''Emits the selected signal for the UI inventory slot to pick up.
	Is Selected: Updates the slot selected boolean.'''
func update_selected(is_selected: bool):
	slot_selected = is_selected
	selected.emit()
