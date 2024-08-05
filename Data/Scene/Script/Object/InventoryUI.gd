extends Control

@onready var inv: Inventory = preload("res://Data/Items/Resources/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open : bool = false

func _ready():
	update_slots()
	close()
	
func update_slots():
	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])
	
func _input(_event):
	if Input.is_action_just_pressed("Open Inventory"):
		if is_open:
			close()
		else:
			open()
	
func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false
