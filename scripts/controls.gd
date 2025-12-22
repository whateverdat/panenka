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
@export var Info : Information

var block_click : bool = false

var is_keeper : bool = false
var has_dived : bool = false

var take_shot_elapsed : float = 0
var take_shot_interval : float = 2
var shot_taken : bool = false

var state : ControlsState = ControlsState.DIRECTION
var is_stage_cleared : bool = false

func _ready() -> void:
	set_indicator_states()
	PenaltyTaker.connect("ShotTaken", _handle_shot_taken)
	Announce.connect("AnnouncerCompleted", _announcer_completed)
	Info.connect("Stage_Cleared", _handle_stage_cleared)
	
func _process(delta: float) -> void:
	if (is_keeper and not shot_taken):
		take_shot_elapsed += delta
		if (take_shot_elapsed >= take_shot_interval):
			PenaltyTaker.prepare_for_shot()
			shot_taken = true
			take_shot_elapsed = 0
			
			
func _input(event):
	if (event is InputEventMouseButton):
		if (event.button_index == 1 and event.pressed):
			
			if (is_keeper):
				if (not has_dived):
					Goalie.dive(true, event.position.x)
					has_dived = true
			
			elif (state != ControlsState.CONFIRMATION): ## This state is auto processed
				if (block_click):
					block_click = false
				_proceed()
				block_click = true
			
		## DEBUG: Repeat the last shot
		#elif (event.button_index == 2 and event.pressed):
		#	Shooting.ready_ball()
		#	Goalie.get_ready()
		#	set_indicator_states()
		

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
	
	if (not is_keeper):		
		Goalie.dive()

func _announcer_completed()-> void:
	if (is_stage_cleared):
		get_tree().change_scene_to_file("res://scenes/shootout.tscn")
		GamestateManager.clear_score_buffers()
		return
		
	if (is_keeper):
		is_keeper = false
		state = ControlsState.CONFIRMATION
		_proceed()
		_show_indicators()
	else:
		is_keeper = true
		block_click = false
		_proceed()
		_hide_indicators()
	
	
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
	shot_taken = false
	has_dived = false
	
func _hide_indicators() -> void:
	DirectionIndicator.hide()
	HeightIndicator.hide()
	SpeedIndicator.hide()
	Goalie.set_skin("team")
	PenaltyTaker.set_skin("opponent")
	pass
	
func _show_indicators() -> void:
	DirectionIndicator.show()
	HeightIndicator.show()
	SpeedIndicator.show()
	Goalie.set_skin("opponent")
	PenaltyTaker.set_skin("team")
	pass
	
func _handle_stage_cleared() -> void:
	is_stage_cleared = true
