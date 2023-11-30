class_name StateIdle
extends State

@export var animator: AnimatedSprite2D
@export var manny: Manny



func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(_delta):
	if manny.is_on_floor():
		animator.play("Idle")
	manny.velocity.x = lerp(manny.velocity.x, 0.0, manny.DECELERATION)
	manny.move_and_slide()
