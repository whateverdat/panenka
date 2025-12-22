extends Node

enum Stages {
	ROUND_OF_32,
	ROUND_OF_16,
	QUARTER_FINAL,
	SEMI_FINAL,
	FINAL,
}

const STAGE_POINTS : Array = [
	1000,
	2000,
	3000,
	5000,
	10000,
]

var score : int
var current_stage : Stages

var shot_taken : int = 0
var opponent_score : int = 0
var opponent_score_buffer : int = 0
var team_score : int = 0
var team_score_buffer : int = 0

func _ready() -> void:
	reset_game()
	pass
	
	
func _process(_delta: float) -> void:
	pass
	
	
func reset_game() -> void:
	current_stage = Stages.ROUND_OF_32
	score = 0
	shot_taken = 0
	opponent_score = 0
	team_score = 0
	
	
func increase_score(amount : int) -> void:
	score += amount
	
	if (amount < 0):
		_opponent_scored()
	elif (amount > 0):
		_team_scored()
		
	if (score < 0):
		score = 0
	
	
func increase_stage() -> void:
	print("Next Stage!")
	shot_taken = 0
	opponent_score = 0
	team_score = 0
	
	var current_state_as_int : int = int(current_stage)
	score += STAGE_POINTS[current_state_as_int]
	current_state_as_int += 1
	
	if (current_state_as_int > 4):
		_terminate_game()
		return
		
	current_stage = current_state_as_int as Stages
	
func _terminate_game() -> void:
	## TODO: Title Screen
	print("Game over, Score: " + str(score))
	
	
func increase_total_shot_taken() -> void:
	print(str(shot_taken))
	shot_taken += 1
	
	
func _opponent_scored() -> void:
	opponent_score += 1
	opponent_score_buffer += 1
	
	
func _team_scored() -> void:
	team_score += 1
	team_score_buffer += 1
	
	
func check_if_round_over() -> bool:
	if (shot_taken < 10):
		var remaining_shots : int = 10 - shot_taken
		var opponent_can_score_times : int = remaining_shots / 2
		if (remaining_shots % 2 != 0):
			opponent_can_score_times += 1
		var player_can_score_times : int = remaining_shots / 2
		var score_difference : int = team_score - opponent_score

		## PLAYER LOST
		if (score_difference < 0 and player_can_score_times < -score_difference):
			_terminate_game()
			return true
			
		## PLAYER WON
		elif (score_difference > 0 and opponent_can_score_times < score_difference):
			increase_stage()
			return true
			
	## SUDDEN DEATH
	elif (shot_taken % 2 == 0):
		var score_difference : int = team_score - opponent_score
		
		## PLAYER LOST
		if (score_difference < 0):
			_terminate_game()
			return true
			
		## PLAYER WON
		elif (score_difference > 0):
			increase_stage()
			return true
	return false
			
		
func clear_score_buffers() -> void:
	team_score_buffer = 0
	opponent_score_buffer = 0
		
		
