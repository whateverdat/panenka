extends Node2D

@export var Direction : Label
@export var Height : Label
@export var Speed : Label
@export var Missed : Label
@export var ZIndex : Label

@export var Shoot : ShootingScript

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	Direction.text = "Direction: " + str(Shoot.direction)
	Height.text = "Height: " + str(Shoot.height)
	Speed.text = "Speed: " + str(Shoot.speed)
	Missed.text = "Missed: " + str(Shoot.missed)
	ZIndex.text = "Z Index: " + str(Shoot.Ball_Sprite.position.y)
