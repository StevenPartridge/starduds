extends RigidBody2D

# Asset options for space rocks
var space_rock_assets = ["res://assets/space_background_pack/SpaceRock1.png", "res://assets/space_background_pack/SpaceRock2.png", "res://assets/space_background_pack/SpaceRock3.png"]

# Size, rotation, and movement parameters
var min_size: float = 0.1
var max_size: float = 0.4
var min_rotation_speed: float = 0.1
var max_rotation_speed: float = 1.0
var min_movement_speed: float = 10
var max_movement_speed: float = 50

func _ready():
	# Randomize asteroid appearance and behavior
	randomize_asteroid()

func randomize_asteroid():
	# Choose a random sprite
	var sprite = $Sprite2D
	sprite.texture = load(space_rock_assets[randi() % space_rock_assets.size()])

	# Randomize size
	var size = randf_range(min_size, max_size)
	sprite.scale = Vector2(size, size)

	# Set physics properties based on size
	mass = size * 10  # Adjust as needed
	linear_damp = 1.0  # Adjust for "space" feel

	# Randomize rotation and movement
	angular_velocity = randf_range(min_rotation_speed, max_rotation_speed)
	linear_velocity = Vector2(randf_range(min_movement_speed, max_movement_speed), 0).rotated(randf() * 2.0 * PI)

func _integrate_forces(state):
	# Adjust physics behavior here if needed
	pass

func _on_Asteroid_body_entered(body):
	# Handle collisions (e.g., nudge asteroid, damage to ship)
	pass
