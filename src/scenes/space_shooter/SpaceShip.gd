extends Node2D

@onready var sprite_2d: Sprite2D = $CharacterBody2D/Sprite2D as Sprite2D


# Define speed and rotation adjustment variables
var speed: float = 200 # Adjust as needed
var rotation_speed: float = 25 # Degrees to rotate per frame
var velocity: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Initialization can be added here if necessary.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction: Vector2 = Vector2.ZERO
	var rotation_change: Vector2 = Vector2.ZERO

	# Handle movement input
	if Input.is_action_pressed("MoveRight"):
		direction.x += 1
		rotation_change.y -= rotation_speed * delta
	if Input.is_action_pressed("MoveLeft"):
		direction.x -= 1
		rotation_change.y += rotation_speed * delta
	if Input.is_action_pressed("Down"):
		direction.y += 1
		rotation_change.x += rotation_speed * delta
	if Input.is_action_pressed("Up"):
		direction.y -= 1
		rotation_change.x -= rotation_speed * delta

	# Update position and rotation
	velocity = direction.normalized() * speed
	position += velocity * delta

	if sprite_2d.material:
		var shader: ShaderMaterial = sprite_2d.get_material() as ShaderMaterial
		shader.set_shader_parameter("x_rot", rotation_speed * direction.x * .5)
		shader.set_shader_parameter("y_rot", rotation_speed * direction.y)
