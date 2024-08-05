extends Panel

@onready var display: Sprite2D = $ItemDisplay

func update(item: InvItem):
	if !item:
		display.visible = false
	else:
		display.visible = true
		display.texture = item.texture
