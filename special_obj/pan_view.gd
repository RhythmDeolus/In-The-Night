extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (int) var move = 0
export (int) var speed = 0
export (bool) var enabled = false
export (float) var start_pause = 0
export (float) var end_pause = 0
var already_ran = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

onready var camera = get_parent().get_node("player/Camera2D2")
onready var player = get_parent().get_node("player")
onready var pan_camera = $"Camera2D"

export var stop_music = false

func _physics_process(delta):
	if enabled and not already_ran:
		if start_pause > 0:
			start_pause -= delta
		elif move > 0:
			move -= abs(speed * delta)
			position.x += speed * delta
		elif end_pause > 0:
			end_pause -= delta
		else:
#			pan_camera.clear_current()
			camera.make_current()
			player.pause(false)
			already_ran = true

func _on_VisibilityNotifier2D_screen_entered():
	if enabled:
		return
	position = camera.get_camera_screen_center() - Vector2(get_viewport_rect().size.x /2, get_viewport_rect().size.y/2)
#	camera.clear_current()
	pan_camera.make_current()
	player.pause()
	enabled = true
	if stop_music: Global.music_player.play_music('before_boss')
	pass # Replace with function body.
