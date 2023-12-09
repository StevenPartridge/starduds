extends Node2D

@export var level_requirement: int = 5

@onready var manny = $Manny5

# Called when the node enters the scene tree for the first time.
func _ready():
	manny.inventory.reset_item_counts()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	check_portal()
	
func check_portal():
	var inventory: Inventory = manny.get_inventory()
	var all_children = get_children()
	for item in inventory.items:
		if item.name == "Coin":
			for portal in all_children:
				if portal.is_in_group("portal") and item.count >= level_requirement:
					portal.visible = true
