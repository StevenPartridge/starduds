extends Node2D

# Speed of the enemy
const SPEED: float = 100 # 100 normally, testing with 1
@onready var progress_bar: ProgressBar = $EnemyDartWing/ProgressBar as ProgressBar
@onready var spawner_component: SpawnerComponent = $EnemyDartWing/SpawnerComponent as SpawnerComponent

# Reference to the target node
var target: Node2D
@onready var stats_component: StatsComponent = $EnemyDartWing/StatsComponent as StatsComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	# Assuming the target node is named 'Player'
	if get_tree().get_nodes_in_group("player").size() > 0:
		target = get_tree().get_nodes_in_group("player")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress_bar.value = stats_component.health
	
	if stats_component.health < 0:
		spawner_component.spawn(global_position)
		queue_free()

	if target:
		# Rotate towards the target
		look_at(target.global_position)

		# Move towards the target
		var direction = (target.global_position - global_position).normalized()
		position += direction * SPEED * delta
		
func _take_damage(damage: float) -> void:
	stats_component.health = stats_component.health - damage
