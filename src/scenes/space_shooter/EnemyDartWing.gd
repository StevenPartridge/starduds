extends CharacterBody2D

# Speed of the enemy
const SPEED: float = 100

# Reference to the target node
var target: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Assuming the target node is named 'Player'
	if get_tree().get_nodes_in_group("player").size() > 0:
		target = get_tree().get_nodes_in_group("player")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target:
		# Rotate towards the target
		look_at(target.global_position)

		# Move towards the target
		var direction = (target.global_position - global_position).normalized()
		position += direction * SPEED * delta