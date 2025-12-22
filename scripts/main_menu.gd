extends Node2D

func _ready() -> void:
	AudioManager.play("whistle")
	pass
	
func _input(event):
	if (event is InputEventMouseButton):
		if (event.button_index == 2 and event.pressed):
			get_tree().change_scene_to_file("res://scenes/shootout.tscn")
			GamestateManager.reset_game()
			
