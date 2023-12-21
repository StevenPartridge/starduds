extends Node2D


var target: Node2D

@export var laser_color: Color = Color(0.0, 0.0, 1.0) # Blue color
@export var laser_width: float = 10.0
var laser_start: Vector2
var laser_end: Vector2

@export var power: float = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	select_target()
	update_laser_positions()
	queue_redraw() # Ensure the _draw() function is called
	do_damage()

func calculate_damage() -> float:
	# TODO: Add a function for random damage per attack
	return power

func do_damage() -> void:
	if !target: pass
	if target.has_method("_take_damage"):
		target._take_damage(calculate_damage())

# Function to select the nearest target
func select_target() -> void:
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.size() > 0:
		if !target: target = enemies[0]
		for enemy in enemies: 
			var distA = get_distance_to_target(enemy)
			var distB = get_distance_to_target(target)
			if distA < distB:
				target = enemy
				return

# Update the laser's start and end positions
func update_laser_positions() -> void:
	if target:
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
