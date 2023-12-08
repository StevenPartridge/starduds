extends Control

@onready var rich_text_label = $ColorRect/RichTextLabel
@export var target_item: String = "Coin"
@export var target_count: int = 5

var player_inventory = preload("res://scenes/platformer/inventory/PlayerInventory.tres")

func _process(_delta):
	if !visible: return
	var coin_total = 0
	for item in player_inventory.items:
		if item.name == target_item:
			coin_total = item.count
	rich_text_label.text = str(coin_total, "/", target_count)
	
func update_value(new_text: String):
	if not new_text:
		return
	rich_text_label.text=str(new_text)
