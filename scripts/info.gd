class_name Information

extends Node2D

signal Stage_Cleared

@export var Penalty_Number : Label
@export var Match_Score : Label
@export var Game_Score : Label


@export var Shoot : ShootingScript

const SCORE_MULTIPLIER : int = 100

func _ready() -> void:
	update_game_score()
	update_match_score()
	
func _process(_delta: float) -> void:
	pass
	
func update_game_score() -> void:
	Game_Score.text = "SCORE: " + str(GamestateManager.score * SCORE_MULTIPLIER)
	
func update_match_score(now : bool = true) -> void:
	if (not now):
		var score_string : String = str(GamestateManager.team_score_buffer) + " : " + str(GamestateManager.opponent_score_buffer)	
		Match_Score.text = score_string
		emit_signal("Stage_Cleared")
		return
		
	var string : String = str(GamestateManager.team_score) + " : " + str(GamestateManager.opponent_score)	
	Match_Score.text = string
	
	var stage_string : String = ""
	match GamestateManager.current_stage:
		0:
			stage_string = "ROUND OF 32"
		1:
			stage_string = "ROUND OF 16"
		2:
			stage_string = "QUARTER-FINALS"
		3:
			stage_string = "SEMI-FINALS"
		4: 
			stage_string = "FINALS"
			
	var penalty : int = GamestateManager.shot_taken
	if (penalty < 10):
		Penalty_Number.text = stage_string + ": PENALTIES #" + str(int(penalty / 2) + 1)
	else:
		Penalty_Number.text = stage_string + ": SUDDEN DEATH"
