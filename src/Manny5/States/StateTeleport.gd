class_name StateTeleport
extends State

@export var animator: AnimatedSprite2D
@export var manny: Manny
@export var animation_player: AnimationPlayer


func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	animator.play("Run")
	manny.velocity = Vector2.ZERO  # Reset velocity

	var target = Vector2(manny.move_to[0], manny.move_to[1])
	if target != Vector2.ZERO:
		var direction = (target - manny.position).normalized()
		manny.velocity = direction * 120

		if manny.position.distance_to(target) < 1:
			manny.velocity = Vector2.ZERO  # Stop moving
			manny.move_to = [0.0, 0.0]  # Reset target

	manny.move_and_slide()
