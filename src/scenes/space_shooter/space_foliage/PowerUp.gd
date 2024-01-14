extends Area2D

var speed: float = 120
var move_to: Vector2 = Vector2.ZERO
var is_gravity: bool = false
var velocity: Vector2 = Vector2.ZERO
var collect_distance: float = 1.0
var target_ship: Node2D  # Reference to the ship node

func _on_area_entered(area):
	if area.name == "ItemCollector":
		pass

	if area.get_parent().has_method("collect_powerup"):
		area.get_parent().collect_powerup()
		queue_free()

func gravity_to(ship: Node2D):
	target_ship = ship
	is_gravity = true

func _physics_process(delta):
	if is_gravity and target_ship:
		move_to = target_ship.global_position  # Continuously update target position

		if move_to != Vector2.ZERO:
			var direction = (move_to - position).normalized()
			velocity = direction * speed

	position += velocity * delta
