extends State

@export var idle_state : State
@export var air_state : State
# Called when the node enters the scene tree for the first time.
func enter() -> void:
	print("movement")

func process_input(_event: InputEvent):
		
	return null

func process_physics(_delta : float) -> State:
	parent.move()
	
	if parent.move_dir.is_zero_approx() and parent.is_on_floor():
		return idle_state
	
	if !parent.is_on_floor():
		return air_state
	
	if !parent.jump_buffer.is_stopped():
		parent.jump()
		return air_state
	
	return null
