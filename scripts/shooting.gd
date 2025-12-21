class_name ShootingScript

extends Node

enum BallState {
	READY,
	TRAVELLING,
	STOPPED,
}

@export var Ball : Node2D 
@export var Ball_Sprite : Sprite2D
@export var Goal : Area2D

const BACK_OF_THE_NET : int = 35
const LEFT_POST : int = 95
const RIGHT_POST : int = 225

const MAX_LEFT : int = -100
const MAX_RIGHT : int = 100
const MAX_HEIGHT : int = 200
const MAX_SPEED : float = 250
const MIN_SPEED : float = 75

const BALL_START_POSITION : Vector2 = Vector2(160, 150)

const GRAVITY : int = 100
const SPEED_DECAY : int = 25

var missed : int = 0
var hit_post : bool = false

var initial_speed : float
var initial_direction : float

var direction : float = 0
var height : float = 0
var speed : float = MIN_SPEED
var state : BallState = BallState.READY

var z_axis : float = 0

func _ready() -> void:
	pass
	

func _process(delta: float) -> void:
	match state:
		BallState.TRAVELLING:
			var speed_ratio := speed / initial_speed
			
			direction = initial_direction * speed_ratio
			Ball.position.x += direction * delta
			
			if (speed > 0):
				Ball.position.y -= speed * delta
				speed -= SPEED_DECAY * delta
				
			var collision := Goal.get_overlapping_areas()
			if (Ball.position.y <= BACK_OF_THE_NET and 
			missed != -1 and collision.size() > 0):
				
				if (missed != 1 and Ball_Sprite.position.y < -40):
					missed = -1 
				else:
					missed = 1
					Ball.position.y = BACK_OF_THE_NET + 5
					speed = 0
					if (Ball.position.x > RIGHT_POST):
						Ball.position.x = RIGHT_POST
					elif (Ball.position.x < LEFT_POST):
						Ball.position.x = LEFT_POST
				
			if (collision.size() > 0 and not hit_post):
				if (Ball.position.x < LEFT_POST or Ball.position.x > RIGHT_POST):
					initial_direction *= -1
					direction *= -1
					hit_post = true
									
			## Sprite offset for depth
			Ball_Sprite.position.y -= z_axis * delta
			z_axis -= GRAVITY * delta
			if (Ball_Sprite.position.y > 0): 
				height *= 0.75
				z_axis = height
		
			if (speed < 1 and missed == 0):
				if (collision.size() ==0):
					missed = -1
				else:
					missed = 1
					
			if (Ball.position.y < 0):
				missed = -1
		
		BallState.STOPPED:
			pass
			
		BallState.READY:
			pass
			
				
func ready_ball() -> void:
	missed = false
	hit_post = false
	Ball.position = BALL_START_POSITION
	state = BallState.READY
	Ball_Sprite.position.y = 0
	direction = 0
	height = 0
	z_axis = 0
	initial_speed = 0
	initial_direction = 0
	speed = MIN_SPEED
	
	
func shoot(bar_direction : float, bar_height: float, bar_speed : float) -> void:
	direction = remap_value(bar_direction, -68, 68, MAX_LEFT, MAX_RIGHT)
	height = remap_value(bar_height, -68, 68, 0, MAX_HEIGHT)
	speed = remap_value(bar_speed, -68, 68, MIN_SPEED, MAX_SPEED)
	initial_speed = speed
	initial_direction = direction
	state = BallState.TRAVELLING
	
func remap_value(v: float, old_min := -68.0, old_max := 68.0, new_min := -25.0, new_max := 25.0) -> float:
	var t := (v - old_min) / (old_max - old_min)
	return new_min + t * (new_max - new_min)
	
func colliding_with_post() -> bool:
	var is_colliding : bool = false
	return is_colliding
