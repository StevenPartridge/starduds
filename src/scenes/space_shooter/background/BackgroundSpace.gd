extends Node2D

var sprite_2d: Sprite2D

func _ready():
	if get_tree().get_nodes_in_group("has_shader").size() > 0:
		sprite_2d = get_tree().get_nodes_in_group("has_shader")[0]

func _process(_delta):
	pass

func _set_velocity(velocity: Vector2):
	if sprite_2d and sprite_2d.material:
		var shader: ShaderMaterial = sprite_2d.get_material() as ShaderMaterial
		var movement = shader.get_shader_parameter("mouse")
		movement[0] += velocity[0]
		movement[1] += velocity[1]
		shader.set_shader_parameter("mouse", movement)
	pass
