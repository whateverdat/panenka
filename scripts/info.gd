class_name Information

extends Node2D

signal Stage_Cleared

@export var Penalty_Number : Label
@export var Match_Score : Label
@export var Game_Score : Label


@export var Shoot : ShootingScript

func _ready() -> void:
	update_game_score()
	update_match_score()
	
func _process(_delta: float) -> void:
	pass
	
func update_game_score() -> void:
	Game_Score.text = "score: " + str(GamestateManager.score)
	
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
			stage_string = "round of 32"
		1:
			stage_string = "round of 16"
		2:
			stage_string = "quarter-finals"
		3:
			stage_string = "semi-finals"
		4: 
			stage_string = "finals"
			
	var penalty : int = GamestateManager.shot_taken
	if (penalty < 10):
		Penalty_Number.text = stage_string + ": penalties #" + str(int(penalty / 2) + 1)
	else:
		Penalty_Number.text = stage_string + ": sudden death"
