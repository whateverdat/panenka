extends Node

enum ControlsState {
	CONFIRMATION,
	DIRECTION,
	HEIGHT,
	SPEED,
}

@export var Shooting : ShootingScript
@export var Goalie : Keeper
@export var PenaltyTaker : Player

@export var DirectionIndicator : Indicator
@export var HeightIndicator : Indicator
@export var SpeedIndicator : Indicator

@export var Announce : Announcer

var block_click : bool = false

var state : ControlsState = ControlsState.DIRECTION

func _ready() -> void:
	set_indicator_states()
	PenaltyTaker.connect("ShotTaken", _handle_shot_taken)
	Announce.connect("AnnouncerCompleted", _announcer_completed)
	
	
func _process(_delta: float) -> void:
	pass

	
func _input(event):
	if (event is InputEventMouseButton):
		if (event.button_index == 1 and event.pressed 
		and state != ControlsState.CONFIRMATION):
			if (block_click):
				block_click = false
			_proceed()
			block_click = true
			
		## DEBUG: Repeat the last shot
		elif (event.button_index == 2 and event.pressed):
			Shooting.ready_ball()
			Goalie.get_ready()
			set_indicator_states()
		

## Reset/lock-in indicators after user input, take a shot if needed. 
func set_indicator_states() -> void:
	match state:
		ControlsState.CONFIRMATION:
			
			SpeedIndicator.set_state(false)
			PenaltyTaker.prepare_for_shot()
			
		ControlsState.DIRECTION:
			
			_reset_all()
			DirectionIndicator.set_state(true)
			
		ControlsState.HEIGHT:
			
			DirectionIndicator.set_state(false)
			HeightIndicator.set_state(true)
			
		ControlsState.SPEED:
			
			HeightIndicator.set_state(false)
			SpeedIndicator.set_state(true)
		
			
## Find the next appropriate ControlsState after user input.
func get_next_state() -> ControlsState:
	var current_state_as_int : int = int(state)
	current_state_as_int += 1
	if (current_state_as_int > 3):
		current_state_as_int = 0
	var new_state = current_state_as_int as ControlsState
	return new_state
	
func _handle_shot_taken() -> void:
	Shooting.shoot(
			DirectionIndicator.get_bar_position(),
			HeightIndicator.get_bar_position(),
			SpeedIndicator.get_bar_position()
		)
			
	Goalie.dive()

func _announcer_completed()-> void:
	block_click = false
	_proceed()
	
func _proceed() -> void:
	if block_click:
		return
	state = get_next_state()
	set_indicator_states()
		
func _reset_all() -> void:
	DirectionIndicator.reset_arrow()
	HeightIndicator.reset_arrow()
	SpeedIndicator.reset_arrow()
	Shooting.ready_ball()
	Goalie.get_ready()
	PenaltyTaker.reset()
