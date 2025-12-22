class_name Player

extends Node2D

signal ShotTaken

@export var Sprite : AnimatedSprite2D

const INITIAL_POSITION : Vector2 = Vector2(125, 142)
const MOVE_TO : Vector2 = Vector2(152, 132)


func _ready() -> void:
	Sprite.connect("animation_finished", _on_animation_finished)

func prepare_for_shot() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", MOVE_TO, 1)
	tween.tween_callback(_take_a_shot)
	
	pass
	
func _take_a_shot() -> void:
	Sprite.play()
	
	
func reset() -> void:
	position = INITIAL_POSITION
	
func _on_animation_finished() -> void:
	emit_signal("ShotTaken")
	Sprite.set_frame_and_progress(0, 0)
	
	
