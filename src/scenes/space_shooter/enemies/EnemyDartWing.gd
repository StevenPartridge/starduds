extends CharacterBody2D

# Speed of the enemy
const SPEED: float = 100 # 100 normally, testing with 1
@onready var progress_bar: ProgressBar = $ProgressBar as ProgressBar
@onready var spawner_component: SpawnerComponent = $SpawnerComponent as SpawnerComponent

var base_damage: float = 0

# Reference to the target node
var target: Node2D
@onready var stats_component: StatsComponent = $StatsComponent as StatsComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	# Assuming the target node is named 'Player'
	if get_tree().get_nodes_in_group("player").size() > 0:
		target = get_tree().get_nodes_in_group("player")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_on_screen() and stats_component.health == 0:
		if target and target.has_method("get_power"):
			stats_component.health = 20 + target.get_power()
			base_damage = stats_component.health

	progress_bar.value = stats_component.health
	
	if stats_component.health < 0:
		spawner_component.spawn(global_position)
		queue_free()

	if target:
		# Rotate towards the target
		look_at(target.global_position)

		# Move towards the target
		var direction = (target.global_position - global_position).normalized()
		if is_on_screen():
			position += direction * SPEED * delta
		
func _take_damage(damage: float) -> void:
	if stats_component.health == 0:
		if target and target.has_method("get_power"):
			stats_component.health = 20 + target.get_power()
	stats_component.health = stats_component.health - damage
	
func is_on_screen() -> bool:
	var camera = get_viewport().get_camera_2d()
	var screen_rect = camera.get_viewport_rect()
	var padding = Vector2(500, 500)

	# Enlarge the screen_rect by the padding amount
	screen_rect.size += padding
	# Adjust the position to keep the padded rectangle centered
	screen_rect.position += camera.global_position - screen_rect.size * 0.5

	# Now check if the global_position of the enemy is within the adjusted, padded screen_rect
	return screen_rect.has_point(global_position)

func get_damage_dealt():
	var chance = randf()
	# base_damage = starting health, so 20 + player power (5-10)
	var damage = base_damage / randf_range(4, 8)
	
	if chance < 0.2:
		return damage * 1.5
	elif chance < 0.3:
		return 0
	else:
		return damage

func _on_hurtbox_component_hurt(body):
	if body.get_parent().has_method("take_damage"):
		body.get_parent().take_damage(get_damage_dealt())
