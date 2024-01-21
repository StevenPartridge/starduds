extends Node2D

@onready var portal = $portal
@onready var space_ship = $SpaceShip

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !portal.visible and space_ship.get_power() >= 10:
		var rotate_variable = randf_range(0,360)
		portal.visible = true
		portal.position = space_ship.position + Vector2(600, 0).rotated(TAU * randf())
		
		
