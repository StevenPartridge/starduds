extends Node2D

@onready var sprite_2d: Sprite2D = $CharacterBody2D/Sprite2D as Sprite2D
@onready var laser_beam = $LaserBeam

# Maximum speed and acceleration time
const MAX_SPEED: float = 400 # Adjust as needed
const ACCELERATION_TIME: float = 2.0 # Time to reach max speed
const rotation_speed: float = 18.0 # How far the ship rotates (front/back is divided by 2)
const DECELERATION_TIME: float = 3.0 # Time to stop

var previous_direction: Vector2 = Vector2.ZERO
var current_speed: float = 0.0
var acceleration_per_second: float = MAX_SPEED / ACCELERATION_TIME
var deceleration_per_second: float = MAX_SPEED / DECELERATION_TIME
var velocity: Vector2 = Vector2.ZERO

var background: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().get_nodes_in_group("background").size() > 0:
		background = get_tree().get_nodes_in_group("background")[0]
		print(background.get_class())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if laser_beam.target:
		look_at(laser_beam.target.global_position)

	var direction: Vector2 = Vector2.ZERO
	var rotation_change: Vector2 = Vector2.ZERO
		
	# Handle movement input
	if Input.is_action_pressed("MoveRight"):
		direction.x += 1
		rotation_change.y -= 10 * delta
	if Input.is_action_pressed("MoveLeft"):
		direction.x -= 1
		rotation_change.y += 10 * delta
	if Input.is_action_pressed("Down"):
		direction.y += 1
		rotation_change.x += 10 * delta
	if Input.is_action_pressed("Up"):
		direction.y -= 1
		rotation_change.x -= 10 * delta
	# Accelerate to max speed
	if direction != Vector2.ZERO:
		previous_direction = direction
		current_speed = min(current_speed + acceleration_per_second * delta, MAX_SPEED)
	else:
		current_speed = max(current_speed - deceleration_per_second * delta, 0.0)
	
	if direction != Vector2.ZERO:
		# Update position and rotation
		velocity = direction.normalized() * current_speed
	else:
		velocity = previous_direction.normalized() * current_speed

	position += velocity * delta
	
	if background and background.has_method("_set_velocity"):
#		background._set_velocity(velocity)
		pass

	if sprite_2d.material:
		var shader: ShaderMaterial = sprite_2d.get_material() as ShaderMaterial
		shader.set_shader_parameter("x_rot", rotation_speed * direction.x * .5)
		shader.set_shader_parameter("y_rot", rotation_speed * direction.y)
