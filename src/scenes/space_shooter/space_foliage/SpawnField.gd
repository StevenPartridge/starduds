extends Area2D  # This script is attached to the Area2D node defining the spawning area

# Exported variables
@export var scene: PackedScene  # The scene to spawn
@export var density: float = 0.5  # Scale from 0 to 1
@export var cluster_probability: float = 0.5  # Scale from 0 to 1
@export var max_cluster_size: int = 5  # Max size a cluster can be
@onready var spawner_component: SpawnerComponent = $SpawnerComponent as SpawnerComponent

# Ready function
func _ready():
	spawner_component.scene = scene
	# Calculate the number of instances to spawn based on density and the size of the area
	var area_size = get_area_size()  # Get the size of the CollisionShape2D
	var num_instances = int((area_size.x * area_size.y * density / 1000))  # Simple calculation, adjust as needed

	for i in range(num_instances):
		spawner_component.spawn(pick_random_position_within_area())
		# Handle clustering if necessary, you can expand this logic

func get_area_size() -> Vector2:
	var shape = $CollisionShape2D.shape
	if shape is RectangleShape2D:
		return shape.extents * 2  # Assuming the shape is a rectangle, adjust if using different shapes
	return Vector2.ZERO

func pick_random_position_within_area() -> Vector2:
	var area_rect = get_area_size()  # Assuming this returns the unscaled size of the area
	var scale_factor = get_scale()  # Get the scale factor of the Area2D

	# Adjust the area size with the scale factor
	area_rect *= scale_factor

	# Randomly pick a position within the scaled area bounds
	var x = randf_range(-area_rect.x / 2, area_rect.x / 2)
	var y = randf_range(-area_rect.y / 2, area_rect.y / 2)

	# Return the global position plus the random offset
	return global_position + Vector2(x, y)
