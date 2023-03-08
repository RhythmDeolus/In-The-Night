extends KinematicBody2D
var dissonance_projectile = preload("res://special_obj/brain_dissonancee_projectile.tscn")
var rapid_projectile = preload("res://special_obj/rapid_projectile.tscn")
var snowballfall_projectile = preload("res://special_obj/snowball_fall_projectile.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var has_lost = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$Control2/ProgressBar.max_value = hp
	$Control2/ProgressBar.value = hp
	$AnimationPlayer.play("eyerotate")
	pass # Replace with function body.

func start():
	$Control2.visible = true

var mode = "idle"
var hp = 510
var MAXHP = 510
onready var projectiles_node = $projectiles

var dissonance_arr = []
var dissonance_wait_time_diff = 3
var dissonance_wait_time = 0
var dissonance_angle = 0
var dissonance_move_dir = 1
var dissonance_max_angle = 10
var dissonanve_angular_speed = 10

func _dissonance_attack():
	if mode == "idle":
		mode = "dissonance_attack"
	else:
		return
	var n = 4
	var d_theta = 90
	var delta_theta = d_theta /n
	var r = 150
	var theta = 160
	var i = 0
	dissonance_arr = []
	dissonanve_angular_speed = rand_range(10, 15)
	while i < n:
		var projectile_instance = dissonance_projectile.instance()
		projectile_instance.position = r * Vector2(cos(deg2rad(theta + i * delta_theta)), -sin(deg2rad(theta + i * delta_theta)))
		projectile_instance.velocity = (projectile_instance.position).normalized() * 300
		projectile_instance.shoot_time = dissonance_wait_time_diff
		projectiles_node.add_child(projectile_instance)
		dissonance_arr.append(projectile_instance)
		i += 1

var rapid_arr = []
var rapid_shake_time_diff = 1
var rapid_wait_time_diff = 0
var rapid_shake_time = 0
var rapid_wait_time = 0
var r_projectile
var r_pos = Vector2.ZERO
var r_global_pos = Vector2.ZERO

func _rapid_attack():
	if mode == 'idle':
		var n = 5
		var i = 0
		while i < n:
			var projectile_instance = rapid_projectile.instance()
			projectile_instance.position = Vector2(-150, -global_position.y + 50 + 100* i)
			projectile_instance.velocity = Vector2(-400, 0)
			projectiles_node.add_child(projectile_instance)
			rapid_arr.append(projectile_instance)
			i += 1
		r_projectile = rapid_arr[randi() % len(rapid_arr)]
		r_pos = r_projectile.position
		r_global_pos = r_projectile.global_position
		mode = 'rapid_attack'
# Called every frame. 'delta' is the elapsed time since the previous frame.


var snowfall_wait_time_diff = 0.5
var snowfall_wait_time = 0
var snowfall_time_diff = 10
var snowfall_time = 0

func _snowfall_attack():
	if mode == 'idle':
		mode = 'snowfall_attack'

func clear_projectiles():
	for i in projectiles_node.get_children():
		i.queue_free()
	mode = 'idle'

var has_lost_time = 0
var has_lost_time_diff = 5
var fade_at_time = 3
var has_faded =  false
var battle_ended = false

func _physics_process(delta):
	if mode == 'idle':
		pass
	elif mode == 'dissonance_attack':
		dissonance_wait_time += delta
#		print('dissonance_attack')
		if dissonance_wait_time > dissonance_wait_time_diff:
#			print('attack_ended')
			mode = 'idle'
			dissonance_wait_time = 0
			dissonance_angle = 0
			dissonance_move_dir = 1
			return
		var delta_theta = dissonanve_angular_speed * delta  * dissonance_move_dir
		dissonance_angle += delta_theta
		if abs(dissonance_angle) > dissonance_max_angle:
			dissonance_move_dir *= -1
		for i in dissonance_arr:
			i.position = i.position.rotated(deg2rad(delta_theta))
			i.velocity = i.velocity.rotated(deg2rad(delta_theta))
	elif mode == 'rapid_attack':
		if r_projectile:
			if rapid_shake_time < rapid_shake_time_diff:
				rapid_shake_time += delta
				## shake the projectile
				var d_theta = (-(get_parent().player.global_position - r_global_pos).angle_to(Vector2(-1, 0)) - r_projectile.rotation) * delta * 100
				r_projectile.rotate(d_theta)
				r_projectile.velocity = r_projectile.velocity.rotated(d_theta)
				r_projectile.position = r_pos + Vector2(0, (randf() - 0.5) * 20)
			else:
				rapid_shake_time = 0
				r_projectile.shoot()
				rapid_arr.remove(rapid_arr.find(r_projectile))
				r_projectile = null
		else:
			if rapid_wait_time < rapid_wait_time_diff:
				rapid_wait_time += delta
			else:
				rapid_wait_time = 0
				if len(rapid_arr):
					r_projectile = rapid_arr[randi() % len(rapid_arr)]
					r_pos = r_projectile.position
					r_global_pos = r_projectile.global_position
				else:
					mode = 'idle'
	elif mode == 'snowfall_attack':
		if snowfall_time < snowfall_time_diff:
			if snowfall_wait_time < snowfall_wait_time_diff:
				snowfall_wait_time += delta
			else:
				snowfall_wait_time = 0
				var projectile_instance = snowballfall_projectile.instance()
				projectile_instance.position = Vector2(rand_range(-position.x + 25, -150), -global_position.y + 25)
				projectiles_node.add_child(projectile_instance)
			snowfall_time += delta
		else:
			snowfall_time = 0
			mode = 'idle'
	if has_lost:
		if has_lost_time > has_lost_time_diff and not battle_ended:
			get_parent().end_battle()
			battle_ended = true
		if fade_at_time < has_lost_time and not has_faded:
			$AnimationPlayer.play('fade')
			has_faded = true
		has_lost_time += delta
	pass

func change_to_friend():
	$AnimationPlayer.play("friendeye")
	$enemyEyes.hide()
	$friendEyes.show()
	$Control2.hide()

func destroy():
	if not has_lost:
		hp -= 5
		$Control2/ProgressBar.value = hp
		if hp <= 0 and not has_lost:
			has_lost = true
			change_to_friend()
			clear_projectiles()
			get_parent().player.pause()
			Global.boss_battle_music_end()
			mode = 'friend_idle'
