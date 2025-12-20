extends Node2D

@export var Direction : Label
@export var Height : Label
@export var Speed : Label
@export var Missed : Label

@export var Shoot : Node

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	Direction.text = "Direction: " + str(Shoot.direction)
	Height.text = "Height: " + str(Shoot.height)
	Speed.text = "Speed: " + str(Shoot.speed)
	Missed.text = "Missed: " + str(Shoot.missed)
