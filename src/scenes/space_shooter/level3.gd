extends Node2D

@onready var space_ship = $SpaceShip
@onready var camera_2d = $SpaceShip/Camera2D
@onready var progress_bar = $SpaceShip/Camera2D/ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_zoom: float = .4
	print("SpaceShip Velocity", space_ship.get_velocity())
	camera_2d.set_zoom(Vector2(new_zoom, new_zoom)) 

