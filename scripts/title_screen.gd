extends Node2D

@export var Score_Text : Label
@export var Champions : Node2D
@export var Eliminated : Label

func _ready() -> void:
	if (GamestateManager.current_stage >= 4):
		AudioManager.play("cheer")
		Champions.show()
		Eliminated.hide()
	else:
		AudioManager.play("whistle")
		Champions.hide()
		Eliminated.show()
		
	Score_Text.text = "SCORE: " + str(GamestateManager.score * 100)
		
func _input(event):
	if (event is InputEventMouseButton):
		if (event.button_index == 2 and event.pressed):
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
