extends Area2D  # This script is attached to the Area2D node defining the spawning area

@onready var space_ship = $".."

func get_area_size() -> float:
	var shape = $CollisionShape2D.shape
	if shape is CircleShape2D:
		return shape.radius
	return 0.0

func _on_area_entered(body):
	if body.has_method("gravity_to"):
		body.gravity_to(get_parent())
