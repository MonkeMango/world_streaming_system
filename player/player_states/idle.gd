extends State

@export var move_state : State
@export var air_state : State

func enter() -> void:
	super()
	parent.velocity.x = 0
	parent.velocity.z = 0
	print("sol badguy")

func process_input(_event: InputEvent) -> State:
	if parent.is_any_actions_pressed(parent.actions):
		return move_state
	
		
	return null

func process_physics(_delta : float) -> State:
	
	if !parent.jump_buffer.is_stopped() and parent.is_on_floor():
		parent.jump()
		
	if !parent.is_on_floor():
		return air_state
	
		
	return null
