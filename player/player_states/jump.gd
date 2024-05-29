extends State

@export var idle_state : State
@export var move_state : State


# Called when the node enters the scene tree for the first time.
func enter():
	print("super mario")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process_physics(delta : float) -> State:
	parent.move()
	
	parent.velocity.y += parent.get_gravity() * delta
	
	if parent.is_on_floor():
		if !parent.velocity.is_zero_approx():
			return move_state
		else:
			return idle_state
		
	
	return null



