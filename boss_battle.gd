extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var has_started = false
var has_ended = false

var player = null
var pan_speed = 100
var pan_mode = false
var camera = null
var camera_margin = 20
var time_to_pan = 0
var phase = 0

func getCurrentCamera2D():
	var viewport = get_viewport()
	if not viewport:
		return null
	var camerasGroupName = "__cameras_%d" % viewport.get_viewport_rid().get_id()
	var cameras = get_tree().get_nodes_in_group(camerasGroupName)
	for camera in cameras:
		if camera is Camera2D and camera.current:
			return camera
	return null

func _set_collision(val):
	$StaticBody2D.set_collision_layer_bit(0, val)
	$StaticBody2D2.set_collision_layer_bit(0, val)
	$StaticBody2D3.set_collision_layer_bit(0, val)
	$StaticBody2D4.set_collision_layer_bit(0, val)

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_collision(false)  
	pass # Replace with function body.

func _start_battle():
	camera = getCurrentCamera2D()
	if camera:
		$Camera2D.global_position = camera.get_camera_screen_center() - Vector2(get_viewport_rect().size.x /2, get_viewport_rect().size.y/2)
		time_to_pan = abs(($Camera2D.global_position - position).length()) / pan_speed
		$Camera2D.make_current()
		pan_mode = true
		player.pause()
	_set_collision(true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var camera_pos =  null

var t = 3
var t2  = false
var has_been_freed = false
func _physics_process(delta):
	if pan_mode:
		var vect = position - $Camera2D.position
		$Camera2D.position += vect.normalized() * delta * pan_speed
		time_to_pan -= delta
		if time_to_pan <= 0:
			pan_mode = false
			player.pause(false)
			has_started = true
			$brain_boss.start()
			Global.boss_battle_music_start()
	elif has_started:
		if phase == 0:
			phase = 1
		elif phase == 1:
			if t > 5:
				$brain_boss._dissonance_attack()
				t = 0
			t += delta
			if $brain_boss.hp <= $brain_boss.MAXHP * 2 /3:
				phase = 2
		elif phase == 2:
			if $brain_boss.mode == 'idle':
				$brain_boss._rapid_attack()
			if $brain_boss.hp <= $brain_boss.MAXHP * 1 /3:
				phase = 3
				$brain_boss.clear_projectiles()
		elif phase == 3:
			if $brain_boss.mode == 'idle':
				$brain_boss._snowfall_attack()
			if $brain_boss.mode == 'friend_idle':
				phase = 4
	if has_ended:
		var d = camera_pos - $Camera2D.get_camera_screen_center()
		if d.length() < delta * pan_speed and not has_been_freed:
#		if true:
			camera.make_current()
			player.pause(false)
			queue_free()
			has_been_freed = true
		else:
			1
			$Camera2D.position += d.normalized() * pan_speed * delta

func _on_VisibilityNotifier2D_screen_entered():
	_start_battle()
	pass # Replace with function body.


func end_battle():
#	camera.position += $Camera2D.get_camera_screen_center() - camera.get_camera_screen_center()
	## move battle camera to player camera
	player.pause(true)
	has_ended = true
	camera.clear_current()
	camera.make_current()
	camera_pos = camera.get_camera_screen_center()
	$Camera2D.make_current()
	pass

func _on_Area2D_body_entered(body):
	if has_started:
		return
	if body.is_in_group('player'):
		player = body
		_start_battle()
	pass # Replace with function body.
