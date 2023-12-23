class_name Manny
extends CharacterBody2D

enum JumpState {
	FLOOR,
	JUMP,
	DOUBLEJUMP
}

enum Direction {
	LEFT,
	RIGHT,
	UP,
	DOWN
}
@onready var anim = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var ray_cast_2d_right = $RayCast2DRight
@onready var ray_cast_2d_left = $RayCast2DLeft
@onready var ray_cast_2d_right_ankle = $RayCast2DRightAnkle
@onready var ray_cast_2d_left_ankle = $RayCast2DLeftAnkle

@onready var pin_joint_2d = $PinJoint2D

@onready var fsm = $FiniteStateMachine
@onready var state_idle = $FiniteStateMachine/StateIdle
@onready var state_walk = $FiniteStateMachine/StateWalk
@onready var state_jump = $FiniteStateMachine/StateJump
@onready var state_double_jump = $FiniteStateMachine/StateDoubleJump
@onready var wall_land = $FiniteStateMachine/WallLand
@onready var state_wall_jump = $FiniteStateMachine/StateWallJump
@onready var state_land = $FiniteStateMachine/StateLand
@onready var state_crouch = $FiniteStateMachine/StateCrouch
@onready var state_push_pull_idle = $FiniteStateMachine/StatePushPullIdle
@onready var state_teleport = $FiniteStateMachine/StateTeleport

@export var coins_ui: Control


var player_inventory: Inventory = preload("res://scenes/platformer/inventory/PlayerInventory.tres")

@export var SPEED = 100.0
@export var NUDGE_SPEED = 1.0
@export var SPEED_SPRINT = 200.0
@export var SPEED_PUSH_PULL = 50.0
@export var JUMP_VELOCITY = -500.0
@export var DECELERATION = 0.12
@export var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity") as float
@export var jump_state = JumpState.JUMP
var current_time = 0.0
var input_delay_until = 0.0
var is_teleport: bool = false
var move_to = [0.0, 0.0]

@export var inventory: Inventory

@export var can_double_jump = true

func _ready():
	fsm.change_state(state_idle)

func _physics_process(delta):
	current_time += delta
	if Input.is_action_pressed("Jump"):
		velocity.y += GRAVITY * delta / 2
	else:	
		velocity.y += GRAVITY * delta
		
	update_state()

func get_collider():
	var right = ray_cast_2d_right.get_collider()
	var left = ray_cast_2d_left.get_collider()
	if right:
		return right
	if left:
		return left

func get_ankle_collider():
	var right = ray_cast_2d_right_ankle.get_collider()
	var left = ray_cast_2d_left_ankle.get_collider()
	if right:
		return right
	if left:
		return left

func get_ankle_collider_direction():
	var right = ray_cast_2d_right_ankle.get_collider()
	var left = ray_cast_2d_left_ankle.get_collider()
	if right and !left:
		return Direction.RIGHT
	if left and !right:
		return Direction.LEFT
	
func should_nudge() -> bool:
	var direction = get_enum_direction()
	var nudge_direction = get_ankle_collider_direction()
	if (nudge_direction == null or direction == null) or direction != nudge_direction:
		return false
	var ankle_collider = get_ankle_collider()
	var mid_collider = get_collider()
	if !mid_collider and ankle_collider and ankle_collider.is_in_group("World"):
		return true
	return false

func get_is_grab_allowed():	
	var collider = get_collider()
	if collider is Node:
		if collider.is_in_group("can_push_pull"):
			return true
	return false

func get_is_wall_land_allowed():	
	var collider = get_collider()
	if collider is Node:
		return true
	return false

func get_input_direction() -> int:
	var direction = 0
	if Input.is_action_pressed("MoveLeft"):
		direction -= 1
	if Input.is_action_pressed("MoveRight"):
		direction += 1
	return direction

func get_enum_direction():
	var direction = 0
	if Input.is_action_pressed("MoveLeft"):
		direction -= 1
	if Input.is_action_pressed("MoveRight"):
		direction += 1
	
	if direction > 0:
		return Direction.RIGHT
	elif direction < 0:
		return Direction.LEFT
	

const WALL_JUMP_DELAY = 0.5
const DOUBLE_JUMP_DELAY = 0.2
const JUMP_DELAY = 0.1
const LAND_DELAY = 0.15
func update_state():
	if is_teleport:
		fsm.change_state(state_teleport)
	if is_on_floor():
		jump_state = JumpState.FLOOR
	if input_delay_until > current_time:
		return
	var direction = get_input_direction()
	var is_moving = direction != 0
	var is_jumping = Input.is_action_just_pressed("Jump") and jump_state == JumpState.FLOOR
	var is_double_jumping = Input.is_action_just_pressed("Jump") and jump_state == JumpState.JUMP and !is_on_floor()
	var is_fall_jumping = Input.is_action_just_pressed("Jump") and !is_on_floor()
	var is_crouching = Input.is_action_pressed("Crouch") and is_on_floor() and jump_state == JumpState.FLOOR
	var is_interacting = Input.is_action_pressed("Interact")
	if !is_interacting:
		$PinJoint2D.node_b = $PinJoint2D.node_a

	# Jump Logic
	if is_crouching:
		fsm.change_state(state_crouch)	
	elif is_jumping and is_on_floor():
		input_delay_until = current_time + JUMP_DELAY
		fsm.change_state(state_jump)
	elif !is_on_wall() and (is_double_jumping or is_fall_jumping):
		input_delay_until = current_time + DOUBLE_JUMP_DELAY
		fsm.change_state(state_double_jump)
	elif is_double_jumping and is_on_wall() and !is_on_floor():
		input_delay_until = current_time + WALL_JUMP_DELAY
		fsm.change_state(state_wall_jump)
	elif !is_on_floor() and is_on_wall():
		fsm.change_state(wall_land)
	elif is_on_floor():
		if (fsm.state == state_jump or fsm.state == state_double_jump or fsm.state == state_wall_jump):
			input_delay_until = current_time + LAND_DELAY
			fsm.change_state(state_land)
		elif is_moving and !is_interacting:
			fsm.change_state(state_walk)
		elif is_interacting and get_is_grab_allowed():
			$PinJoint2D.node_b = get_collider().get_path()
			fsm.change_state(state_push_pull_idle)
		else:
			fsm.change_state(state_idle)

func reset_jump_states():
	jump_state = JumpState.FLOOR  # Reset double jump when on the floor
	
func collect_coin():
	if not coins_ui:
		return
	for item in inventory.items:
		if item.name == "Coin":
			item.count += 1
			coins_ui.update_value(str(item.count))
			
func get_inventory() -> Inventory:
	return inventory

func teleport_to(location: String) -> void:
	
	await get_tree().create_timer(0.4).timeout
	SceneManager.SwitchScene(location)
	
func gravity_to(x: int, y: int):
	is_teleport = true
	animation_player.play("teleport")
	move_to = [x,y]
