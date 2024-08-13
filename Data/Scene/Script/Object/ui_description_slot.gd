extends NinePatchRect

# Ties the inventory slot class to this node.
@export var slot : InventorySlot

# Readies the ItemDisplay, a Sprite2D which will hold the texture of an item.
@onready var display : Sprite2D = $DescriptionCenterContainer/DisplaySprite2D

# Readies the labels used for description.
@onready var name_label : Label = $ItemNameLabel
@onready var desc_label : Label = $ItemDescLabel
@onready var market_label : Label = $ItemMarketLabel
@onready var sell_label : Label = $ItemSellLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

'''Updates the ItemDisplay with a given InventorySlot.
	New Slot: A new InventorySlot to initalize in this node.'''
func update_by_slot(new_slot: InventorySlot):
	slot = new_slot
	update()

'''Updates the ItemDisplay by inventory slot.'''
func update():
	# The item that this slot holds.
	var item = slot.slot_item
	
	# If there is no item in this slot, then there will be nothing for the item display.
	if !item:
		visible = false
		display.texture = null
	# Otherwise, make the display visible and set the texture to the inventory item.
	else:
		visible = true
		display.texture = item.atlas_texture.atlas
		display.region_rect = item.atlas_texture.region
		update_labels(item.item_id)
		
'''Update the labels for item description.'''
func update_labels(id: int):
	# Gets item data from dictionary.
	var item_data = Global.dict_item_data[id]
	name_label.text = item_data[Global.ITEM_NAME]
	desc_label.text = item_data[Global.ITEM_DESC]
	# If item price is unavailable, it's N\A
	if item_data[Global.ITEM_PRICE] == null:
		market_label.text = "N\\A"
	else:
		market_label.text = "$" + str(item_data[Global.ITEM_PRICE])
		
	# If item sell price is unavailable, it's N\A
	if item_data[Global.ITEM_SELL] == null:
		sell_label.text = "N\\A"
	else:
		sell_label.text = "$" + str(item_data[Global.ITEM_SELL])
