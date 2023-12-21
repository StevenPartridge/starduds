extends Node2D

@export var laser_color: Color = Color(0.0, 0.0, 1.0) # Blue color
@export var laser_width: float = 10.0
@export var power: float = 5
@export var attack_delay: float = 1

var target: Node2D
var laser_start: Vector2
var laser_end: Vector2
var damage_delay: float = 0


func _process(delta):
	damage_delay -= delta  # Decrement the damage delay

	if not target or not is_instance_valid(target):  # Check if target exists and is in the tree
		select_target()

	update_laser_positions()
	queue_redraw()  # Ensure the _draw() function is called
	do_damage()

func calculate_damage() -> float:
	# TODO: Add a function for random damage per attack
	return power

func do_damage() -> void:
	if not target or damage_delay > 0:  # Check if target exists and if delay is still active
		return
	if target.has_method("_take_damage"):
		damage_delay = attack_delay
		target._take_damage(calculate_damage())

# Function to select the nearest target
func select_target() -> void:
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.size() > 0:
		if !target: target = enemies[0]
		for enemy in enemies: 
			var distEnemy = get_distance_to_target(enemy)
			var distTarget = get_distance_to_target(target)
			if distEnemy < distTarget:
				target = enemy
				return

func update_laser_positions() -> void:
	if target and is_instance_valid(target):  # Check if target exists and is in the tree
		laser_start = position
		laser_end = to_local(target.global_position)
	else:
		laser_start = Vector2.ZERO
		laser_end = Vector2.ZERO

# Utility function to get distance to a target
func get_distance_to_target(target_body: Node) -> float:
	return position.distance_to(to_local(target_body.position))

# Function to draw the laser
func _draw():
	if target != null:
		draw_line(laser_start, laser_end, laser_color, laser_width)
