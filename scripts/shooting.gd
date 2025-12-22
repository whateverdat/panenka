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

@export var MissedBG : Sprite2D
@export var ScoredBG : Sprite2D

@export var Goalie : Keeper
@export var Announce : Announcer

const BACK_OF_THE_NET : int = 40
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

var announced : bool = false

func _ready() -> void:
	Engine.max_fps = 60 ## Take this to somewhere else
	pass
	

func _process(delta: float) -> void:
	match state:
			
		BallState.TRAVELLING:
			_update_ball(delta)
			
		BallState.STOPPED:
			pass
			
		BallState.READY:
			pass
			
				
func ready_ball() -> void:
	Ball.show()
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
	MissedBG.hide()
	ScoredBG.hide()
	Goalie.z_index = 0
	Ball.z_index = 0
	MissedBG.z_index = 0
	announced = false
	
	
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
	
	
func _determine_goal() -> void:
	if (announced): return
	match (missed):
		1:
			Goalie.z_index = 100
			Ball.z_index = 50
			if (initial_speed == MIN_SPEED):
				Announce.announce("Panenka!")
			elif (hit_post):
				Announce.announce("From the post!")
			elif (initial_speed == MAX_SPEED):
				Announce.announce("Power shot!")
			else:
				Announce.announce("Goal!")
		-1:
			if (Ball.is_visible_in_tree()):
				Announce.announce("Missed!")
			else:
				Announce.announce("Saved!")
	announced = true
			
			
func _update_ball(delta : float) -> void:
	if (Goalie.collider_size > 1 and missed == 0 and Ball_Sprite.position.y > -50):
		AudioManager.play("keeper_save")
		Goalie.saved()
		Ball.hide()
		speed = 0
		missed = -1
		_determine_goal()

	var speed_ratio := speed / initial_speed
	direction = initial_direction * speed_ratio
	Ball.position.x += direction * delta

	if (speed > 0):
		Ball.position.y -= speed * delta
		speed -= SPEED_DECAY * delta
		
	if (Ball.position.y <= BACK_OF_THE_NET and missed == 0):
		var collision := Goal.get_overlapping_areas()
		if (collision.size() > 1):
			if (Ball_Sprite.position.y + -speed < -100):
				if (Ball_Sprite.position.y < -75):
					missed = -1 
					_determine_goal()
					MissedBG.show()
					Goalie.z_index = 100
					Ball.z_index = 50
					MissedBG.z_index = 75
				else:
					missed = 1
					_determine_goal()
					ScoredBG.show()
					Ball.position.y = BACK_OF_THE_NET
					speed = 0
					if (Ball.position.x > RIGHT_POST):
						Ball.position.x = RIGHT_POST
					elif (Ball.position.x < LEFT_POST):
						Ball.position.x = LEFT_POST
						
			else:
				missed = 1
				_determine_goal()
				ScoredBG.show()
				Ball.position.y = BACK_OF_THE_NET
				speed = 0
				if (Ball.position.x > RIGHT_POST):
					Ball.position.x = RIGHT_POST
				elif (Ball.position.x < LEFT_POST):
					Ball.position.x = LEFT_POST
					
		if (speed < 1):
			if (collision.size() == 1):
				missed = -1
				_determine_goal()
				MissedBG.show()
				Goalie.z_index = 100
				Ball.z_index = 50
				MissedBG.z_index = 75
				
			else:
				missed = 1
				_determine_goal()
				ScoredBG.show()
				
	if (not hit_post and missed != -1):
		if (Ball.position.x < LEFT_POST or Ball.position.x > RIGHT_POST):
			var collision := Goal.get_overlapping_areas()
			if (collision.size() > 1):
				initial_direction *= -1
				direction *= -1
				hit_post = true
				AudioManager.play("post_hit")
							
	## Sprite offset for depth
	Ball_Sprite.position.y -= z_axis * delta
	if (missed == 1 and Ball_Sprite.position.y < -60):
		z_axis += -50
		
	z_axis -= GRAVITY * delta
	if (Ball_Sprite.position.y > 0): 
		height *= 0.75
		z_axis = height

	if (Ball.position.y < 0):
		missed = -1
		_determine_goal()
		
