extends Resource

class_name Inventory

@export var items: Array[InventoryItem]

func reset_item_counts() -> void:
	for item in items:
		item.count = 0
