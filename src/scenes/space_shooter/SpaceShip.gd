extends Node2D

@onready var sprite_2d: Sprite2D = $CharacterBody2D/Sprite2D as Sprite2D
@onready var laser_beam = $LaserBeam

# Movement parameters
const MAX_SPEED: float = 600
const ACCELERATION_TIME: float = 2.0
const DECELERATION_TIME: float = 3.0
const MAX_ROTATION_SPEED: float = 1.0 # Maximum rotation speed in radians per second

var velocity: Vector2 = Vector2.ZERO
var target_direction: Vector2 = Vector2.ZERO
var target_rotation: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	# ... Background initialization ...
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_input(delta)
	handle_movement(delta)
	handle_rotation(delta)
#	update_visuals()

# Handle user input
func handle_input(delta):
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
	if target_direction.length() > 0:
		var angle_difference = fmod(target_rotation - rotation, 2 * PI)
		if angle_difference > PI:
			angle_difference -= 2 * PI
		elif angle_difference < -PI:
			angle_difference += 2 * PI

		rotation += clamp(angle_difference, -MAX_ROTATION_SPEED * delta, MAX_ROTATION_SPEED * delta)
