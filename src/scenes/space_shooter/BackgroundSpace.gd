extends Node2D

var sprite_2d: Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().get_nodes_in_group("has_shader").size() > 0:
		sprite_2d = get_tree().get_nodes_in_group("has_shader")[0]
		print(sprite_2d.get_class())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_velocity(velocity: Vector2):
	print(velocity)
	if sprite_2d and sprite_2d.material:
		var shader: ShaderMaterial = sprite_2d.get_material() as ShaderMaterial
		var movement = shader.get_shader_parameter("mouse")
		movement[0] += velocity[0]
		movement[1] += velocity[1]
		shader.set_shader_parameter("mouse", movement)
	pass