extends Node

enum ControlsState {
	CONFIRMATION,
	DIRECTION,
	HEIGHT,
	SPEED,
}

@export var Shooting : ShootingScript

@export var DirectionIndicator : Indicator
@export var HeightIndicator : Indicator
@export var SpeedIndicator : Indicator

var state : ControlsState = ControlsState.DIRECTION

func _ready() -> void:
	set_indicator_states()
	
func _process(_delta: float) -> void:
	pass
	
func _input(event):
	if (event is InputEventMouseButton):
		if (event.button_index == 1 and event.pressed):
			state = get_next_state()
			set_indicator_states()
		elif (event.button_index == 2 and event.pressed):
			Shooting.ready_ball()
			set_indicator_states()
		
func set_indicator_states() -> void:
	match state:
		ControlsState.CONFIRMATION:
			DirectionIndicator.set_state(false)
			HeightIndicator.set_state(false)
			SpeedIndicator.set_state(false)
			
			Shooting.shoot(
				DirectionIndicator.get_bar_position(),
				HeightIndicator.get_bar_position(),
				SpeedIndicator.get_bar_position()
			)
			
		ControlsState.DIRECTION:
			DirectionIndicator.reset_arrow()
			HeightIndicator.reset_arrow()
			SpeedIndicator.reset_arrow()
			Shooting.ready_ball()
			DirectionIndicator.set_state(true)
			HeightIndicator.set_state(false)
			SpeedIndicator.set_state(false)
			
		ControlsState.HEIGHT:
			DirectionIndicator.set_state(false)
			HeightIndicator.set_state(true)
			SpeedIndicator.set_state(false)
			
		ControlsState.SPEED:
			DirectionIndicator.set_state(false)
			HeightIndicator.set_state(false)
			SpeedIndicator.set_state(true)
		
			
			
func get_next_state() -> ControlsState:
	var current_state_as_int : int = int(state)
	current_state_as_int += 1
	if (current_state_as_int > 3):
		current_state_as_int = 0
	var new_state = current_state_as_int as ControlsState
	return new_state
		
	
