extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var laser_beam = $LaserBeam
@onready var stats_component: StatsComponent = $StatsComponent as StatsComponent

# Movement parameters
const MAX_SPEED: float = 600
const ACCELERATION_TIME: float = 2.0
const DECELERATION_TIME: float = 3.0
const MAX_ROTATION_SPEED: float = 1.2 # Maximum rotation speed in radians per second
const MAX_ROT: float = 18

var velocity: Vector2 = Vector2.ZERO
var target_direction: Vector2 = Vector2.ZERO
var target_rotation: float = 0.0
var previous_rotation: float

func _ready():
	# ... Background initialization ...
	pass

func _process(delta):
	handle_input(delta)
	handle_movement(delta)
	handle_rotation(delta)
	handle_tilt()

func handle_tilt():
	var shader: ShaderMaterial

	if sprite_2d and sprite_2d.material:
		shader = sprite_2d.material as ShaderMaterial
		var y_rot_value: float = 0  # Default to no tilt

		# Assuming 'rotation' is the current rotation of the ship
		# and 'previous_rotation' is the rotation in the last frame
		var rotation_change = rotation - previous_rotation

		# Determine the tilt direction based on the change in rotation
		if rotation_change > 0:  # Turning right (clockwise)
			y_rot_value = MAX_ROT  # Tilt left
		elif rotation_change < 0:  # Turning left (counter-clockwise)
			y_rot_value = -MAX_ROT  # Tilt right

		# Apply the tilt with interpolation for smooth return to neutral
		var current_y_rot = shader.get_shader_parameter("y_rot")
		shader.set_shader_parameter("y_rot", lerp(current_y_rot, y_rot_value, 0.1))

	# Store the current rotation for the next frame's calculation
	previous_rotation = rotation

# Handle user input
func handle_input(_delta):
	target_direction = Vector2.ZERO

	if Input.is_action_pressed("MoveRight"):
		target_direction.x += 1
	if Input.is_action_pressed("MoveLeft"):
		target_direction.x -= 1
	if Input.is_action_pressed("Down"):
		target_direction.y += 1
	if Input.is_action_pressed("Up"):
		target_direction.y -= 1

	if target_direction.length() > 0:
		target_rotation = target_direction.angle()

# Handle the movement of the ship
func handle_movement(delta):
	if target_direction.length() > 0:
		velocity = velocity.move_toward(target_direction.normalized() * MAX_SPEED, delta * MAX_SPEED / ACCELERATION_TIME)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * MAX_SPEED / DECELERATION_TIME)

	position += velocity * delta

# Handle the rotation of the ship
func handle_rotation(delta):
	previous_rotation = rotation
	if target_direction.length() > 0:
		var angle_difference = fmod(target_rotation - rotation, 2 * PI)
		if angle_difference > PI:
			angle_difference -= 2 * PI
		elif angle_difference < -PI:
			angle_difference += 2 * PI

		rotation += clamp(angle_difference, -MAX_ROTATION_SPEED * delta, MAX_ROTATION_SPEED * delta)
		
func collect_powerup():
	print("CollectingPowerupsInThere")
	stats_component.powerups = stats_component.powerups + 1
	laser_beam.power = int(5 + (stats_component.powerups * .5))
