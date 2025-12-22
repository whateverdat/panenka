extends Node

var whistle : AudioStream = preload("res://content/audio/referee-whistle-blow-gymnasium-6320.mp3")
var ball_hit : AudioStream = preload("res://content/audio/sfx100v2_hit_02.ogg")
var post_hit : AudioStream = preload("res://content/audio/sfx100v2_metal_hit_01.ogg")
var keeper_save : AudioStream = preload("res://content/audio/sfx100v2_hit_01.ogg")
var hit_net : AudioStream = preload("res://content/audio/a-football-hits-the-net-goal-313216.mp3")
var cheer : AudioStream = preload("res://content/audio/crowd-cheer-and-applause-406644.mp3")

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
		
func play(filename: String) -> void:
	var audio : AudioStream = _determine_file(filename)
	if (audio == null): return
	
	var audio_player := AudioStreamPlayer.new()
	audio_player.stream = audio
	Engine.get_main_loop().root.add_child.call_deferred(audio_player)
	
	await audio_player.tree_entered
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()
	
func _determine_file(filename : String) -> AudioStream:
	match filename:
		
		"whistle":
			return whistle
			
		"ball_hit":
			return ball_hit
			
		"post_hit":
			return post_hit
			
		"keeper_save":
			return keeper_save
			
		"hit_net":
			return hit_net
			
		"cheer":
			return cheer
			
		_:
			return null
