class_name StateDoubleJump
extends State

@export var animator: AnimatedSprite2D
@export var manny: Manny



func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	handle_horizontal_movement()
	if animator.animation != "JumpRoll":
		animator.play("JumpRoll")
	if manny.jump_state == manny.JumpState.JUMP or manny.jump_state == manny.JumpState.FLOOR:
		apply_jump_force()
		manny.jump_state = manny.JumpState.DOUBLEJUMP
	else:
		manny.velocity.y += manny.GRAVITY * delta
	manny.move_and_slide()

func apply_jump_force():
	manny.velocity.y = manny.JUMP_VELOCITY

func handle_horizontal_movement():
	if abs(manny.get_input_direction()) > 0:
		manny.velocity.x = lerp(manny.velocity.x, manny.get_input_direction() * manny.SPEED, 1)
	else:
		manny.velocity.x = manny.velocity.x

