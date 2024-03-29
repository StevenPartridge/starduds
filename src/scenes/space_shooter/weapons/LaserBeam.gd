extends Node2D

@export var laser_color: Color = Color(0.0, 0.0, 1.0) # Blue color
@export var laser_width: float = 10
@export var power: float = 5.1
@export var attack_delay: float = 1
@export var attack_distance: float = 2000

@onready var color_rect: ColorRect = $ColorRect as ColorRect

var target: Node2D
var laser_start: Vector2
var laser_end: Vector2
var damage_delay: float = 0
@export var is_active: bool = false


func _process(delta):
	if !is_active:
		color_rect.visible = false
		return

	damage_delay -= delta  # Decrement the damage delay
	select_target()
	update_laser_beam()
	do_damage()
	
	if !is_instance_valid(target):
		color_rect.size = Vector2.ZERO

func calculate_damage() -> float:
	var chance = randf()

	var random_variation = randf_range(0.5, 1.5)
	var rolled_damage = power * random_variation # power is known to be between 5 and 10, so this will be min: 2.5, max: 15
		
	# 20% chance of a critical hit
	if chance < 0.2:
		return rolled_damage * 2  # Critical damage is double the power

	# 10% chance of a miss
	elif chance < 0.3:
		return 0  # Miss means no damage

	return rolled_damage

func do_damage() -> void:
	if not target or damage_delay > 0:  # Check if target exists and if delay is still active
		return
	if target.has_method("_take_damage"):
		damage_delay = attack_delay
		target._take_damage(calculate_damage())

func select_target() -> void:
	var nearest_enemy = null
	var nearest_distance = attack_distance
	var laser_direction = Vector2(cos(rotation), sin(rotation)) # Direction in which the laser is facing

	for enemy in get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy):
			continue

		var enemy_direction = (enemy.global_position - global_position).normalized()
		var angle_to_enemy = acos(laser_direction.dot(enemy_direction))

		if angle_to_enemy <= PI / 2: # Check if enemy is within a 180-degree arc
			var distance_to_enemy = global_position.distance_to(enemy.global_position)
			if distance_to_enemy < nearest_distance:
				nearest_enemy = enemy
				nearest_distance = distance_to_enemy

	target = nearest_enemy

# Utility function to get distance to a target
func get_distance_to_target(target_body: Node) -> float:
	return position.distance_to(to_local(target_body.position))

func update_laser_beam() -> void:
	if is_instance_valid(target):
		laser_start = global_position

		# If the ship should shoot towards a target
		laser_end = target.global_position

	var parent_rotation = get_parent().rotation + rotation
	# Calculate direction vector and angle for the laser beam
	var direction = (laser_end - laser_start).normalized()
	var angle = atan2(direction.y, direction.x) - parent_rotation

	# Update ColorRect properties
	var length = laser_start.distance_to(laser_end) * 2
	color_rect.size = Vector2(length, laser_width)
	color_rect.pivot_offset = Vector2(0, laser_width / 2)
	color_rect.rotation = angle
	color_rect.global_position = laser_start
	color_rect.modulate = laser_color
	color_rect.visible = true
	
