extends Node2D

@export var laser_color: Color = Color(0.0, 0.0, 1.0) # Blue color
@export var laser_width: float = 10.0
@export var power: float = 5.1
@export var attack_delay: float = 1
@export var attack_distance: float = 2000

@onready var color_rect: ColorRect = $ColorRect as ColorRect

var target: Node2D
var laser_start: Vector2
var laser_end: Vector2
var damage_delay: float = 0


func _process(delta):
	damage_delay -= delta  # Decrement the damage delay
	

	select_target()
	update_laser_beam()
	do_damage()
	
	if !is_instance_valid(target):
		color_rect.size = Vector2.ZERO

func calculate_damage() -> float:
	# TODO: Add a function for random damage per attack
	return power

func do_damage() -> void:
	if not target or damage_delay > 0:  # Check if target exists and if delay is still active
		return
	if target.has_method("_take_damage"):
		damage_delay = attack_delay
		target._take_damage(calculate_damage())

# Function to select the nearest target within attack distance
func select_target() -> void:
	var nearest_enemy = null
	var nearest_distance = attack_distance

	for enemy in get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy):
			continue

		var distance_to_enemy = get_distance_to_target(enemy)
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

	var parent_rotation = get_parent().rotation
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
