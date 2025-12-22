class_name Announcer

extends Label

signal AnnouncerCompleted

@export var info : Information

const speed : float = 100

const INITIAL_POSITION : Vector2 = Vector2(-320, 0)

const PANENKA_SCORE : int = 100
const FROM_THE_POST_SCORE : int = 50
const POWERSHOT_SCORE : int = 25
const REGULAR_GOAL_SCORE : int = 10
const CONCEDE_GOAL_SCORE : int = -5

func _ready() -> void:
	pass


func reset() -> void:
	text = ""
	position = INITIAL_POSITION
	emit_signal("AnnouncerCompleted")
	
	
func announce(announcement : String) -> void:
	text = announcement.to_upper()
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(320, 0), 3)
	tween.tween_callback(reset)
	
	var total_shots_taken : int = GamestateManager.shot_taken
	var players_turn : bool = total_shots_taken % 2 == 0
	
	match announcement.to_upper():
		
		"PANENKA!":
			if (players_turn):
				GamestateManager.increase_score(PANENKA_SCORE)
			else: 
				GamestateManager.increase_score(CONCEDE_GOAL_SCORE)
				
		"FROM_THE_POST!"	:
			if (players_turn): GamestateManager.increase_score(FROM_THE_POST_SCORE)
			else: 
				GamestateManager.increase_score(CONCEDE_GOAL_SCORE)
			
		"POWER SHOT!":
			if (players_turn):
				GamestateManager.increase_score(POWERSHOT_SCORE)
			else: 
				GamestateManager.increase_score(CONCEDE_GOAL_SCORE)
				
		"GOAL!":
			if (players_turn):
				GamestateManager.increase_score(REGULAR_GOAL_SCORE)
			else: 
				GamestateManager.increase_score(CONCEDE_GOAL_SCORE)
			
	
	GamestateManager.increase_total_shot_taken()
	var update_later : bool = GamestateManager.check_if_round_over()
	info.update_match_score(not update_later)
	info.update_game_score()
	
