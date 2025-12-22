class_name Announcer

extends Label

signal AnnouncerCompleted

const speed : float = 100

const INITIAL_POSITION : Vector2 = Vector2(-320, 0)

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
