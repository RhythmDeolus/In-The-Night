extends AudioStreamPlayer

onready var tween_out = get_node("Tween")

var arr = {
	"main_menu": preload("res://audios/Debussy - Clair de Lune-WNcsUNKlAKw.mp3"),
	"main_level": preload("res://audios/Chopin - Nocturne in E Flat Major (Op. 9 No. 2)-p29JUpsOSTE.mp3"),
	"boss_music": preload("res://audios/Beethoven - Moonlight Sonata (3rd Movement)-BV7RkEL6oRc.mp3"),
	"before_boss": preload("res://audios/Beethoven - Moonlight Sonata (1st Movement)-sbTVZMJ9Z2I.mp3")
}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var next_to_play = null
var transition_duration = 1.00
var transition_type = 1
var start_with = null
var currently_playing = null
var current_vol = 50
var MAX_VOL = 100
var MIN_VOL = 0

func start_with(val):
	start_with = val

func _init():
	pass

func fade_out():
	tween_out.interpolate_property(self, "volume_db", volume_db, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()
# Called when the node enters the scene tree for the first time.
func _ready():
	set_volume(current_vol)
	pass # Replace with function body.

func play_music(val):
	print(currently_playing, val)
	if currently_playing == val:
		return
	if not next_to_play: fade_out()
	if val in arr:
		next_to_play = arr[val]
		currently_playing = val
	else:
		next_to_play = null
		currently_playing = null
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_volume(val):
	volume_db = range_lerp(val,MIN_VOL , MAX_VOL, -30, 20)
	current_vol = val
	
func get_volume():
	return current_vol
func stop_music():
	fade_out()
	next_to_play = null


func _on_Tween_tween_completed(object, key):
	stream = next_to_play
	next_to_play = null
	volume_db = range_lerp(current_vol, MIN_VOL, MAX_VOL, -20, 20)
	play(0)
	pass # Replace with function body.


func _on_musicplayer_ready():
	if start_with in arr: 
		stream = arr[start_with]
		currently_playing = start_with
	play(0)
	pass # Replace with function body.
