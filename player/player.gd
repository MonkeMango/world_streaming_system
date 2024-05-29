class_name Player
extends CharacterBody3D


@export var SPEED = 5.0
var move_dir : Vector3 

var actions : Array = ["forward", "back", "left", "right"];

#makes the jump actually feel good
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = (2.0 * jump_height) / jump_time_to_peak
@onready var jump_gravity : float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity : float = (-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)

# spring arm for camera
@onready var spring_arm : SpringArm3D = $SpringArm3D

@onready var camera : Camera3D = $SpringArm3D/Camera3D

# jump buffer timer
@onready var jump_buffer : Timer = $JumpBuffer

@onready var state_machine = $StateMachine
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# NOTE: State Machine setup
func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	if event.is_action_pressed("jump"):
		jump_buffer.start()

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	move_and_slide()

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	
## Functions used as general setup for the rest of the state machine
#func _unhandled_input(event) -> void:
		#
##
	#if event.is_action_pressed("interact"):
		#camera._camera_shake(0.1, 0.2)
		#$ShaderAnimations/ImpactFrame.play("new_animation")
#


func move() -> void:
	## Grabs move direction
	move_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_dir.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	
	## Implemented so that the player controller goes where the camera goes
	move_dir = move_dir.rotated(Vector3.UP, spring_arm.rotation.y).normalized()
	
	velocity.x = move_dir.x * SPEED
	velocity.z = move_dir.z * SPEED


func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func is_any_actions_pressed(actions : Array) -> bool:
	for action in actions:
		if Input.is_action_pressed(action):
			return true
	return false

func jump() -> void:
	velocity.y = jump_velocity
