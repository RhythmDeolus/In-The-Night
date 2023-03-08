extends KinematicBody2D

var shoot_ball_scene = preload("res://special_obj/shoot_ball.tscn")

export (int) var speed = 400
export (int) var jump_speed = -400
export (int) var gravity = 600

export (int) var push = 100

var _has_gun = false

var checkpoint = null

var velocity = Vector2.ZERO

var is_jumping = false
var is_dying = false
var dying_time_diff = 2
var dying_time = 0

onready var original_collision_mask = collision_mask
onready var original_collision_layer = collision_layer

var paused = false

onready var _animation_sprite = $AnimatedSprite

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

func _ready():
	pass
	
func make_untouchable(val = true):
	if val:
		set_collision_layer(0)
		set_collision_mask(0)
		$Area2D.set_collision_layer(0)
		$Area2D.set_collision_mask(0)
		$AnimatedSprite.z_index = 100
	else:
		collision_layer = original_collision_layer
		collision_mask = collision_mask

func animation_player(name):
	match name:
		'run':
			_animation_sprite.play('run')
		'shoot':
			_animation_sprite.play('shoot')
		'idle':
			_animation_sprite.play('idle')
		'jump':
			_animation_sprite.play('jump')
		
func switch_dir(dir): # dir = true -> left
	if dir:
		_animation_sprite.flip_h = true
	else:
		_animation_sprite.flip_h = false

#func hurt_player():
#	if checkpoint:
#		get_tree().change_scene_to(checkpoint)
#	else: queue_free()

func get_input():
	velocity.x = 0
	if Input.is_action_pressed("shoot"):
		if _has_gun:
			shoot_ball()
	if Input.is_action_pressed("walk_right"):
		velocity.x += speed
	elif Input.is_action_pressed("walk_left"):
		velocity.x -= speed
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or (time_off_ledge < 0.2 and velocity.y >= 0) :
			velocity.y = jump_speed
			is_jumping = true
	
	## animation ##
	if Input.is_action_pressed('shoot'):
		animation_player('shoot')
	elif is_jumping:
		animation_player('jump')
	elif Input.is_action_pressed("walk_right"):
		animation_player('run')
	elif Input.is_action_pressed("walk_left"):
		animation_player('run')
	elif is_on_floor():
		animation_player('idle')
		
	## Switch Dir##
	if Input.is_action_pressed("walk_right"):
		switch_dir(false)
	elif Input.is_action_pressed("walk_left"):
		switch_dir(true)

func pause(val = true):
	paused = val
	if val:
		animation_player('idle')
		
func die():
	is_dying = true
	print('dying')
	make_untouchable()
	velocity.y = jump_speed * 1.2

var time_off_ledge = 0
var time_shoot = 0
var shoot_diff = 0.3	
func _physics_process(delta):
	if paused:
		return
	if is_dying == true:
		dying_time += delta
		position.y += velocity.y * delta
		velocity.y += gravity * delta
		rotate(deg2rad(-180 * delta))
		if dying_time > dying_time_diff:
			dying_time = 0
			rotation = 0
			make_untouchable(false)
			is_dying = false
			Global.go_to_checkpoint()
		return
	time_shoot -= delta
	if time_shoot < 0:
		time_shoot = 0
	if is_on_floor():
		time_off_ledge = 0
		is_jumping = false
	else:
		time_off_ledge += delta
	get_input()
	velocity.y += gravity * delta
	var snap = get_floor_normal()
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			snap = Vector2.ZERO
	velocity = move_and_slide_with_snap(velocity, -snap * 32, Vector2.UP, false, 4, PI/4, false)
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("moveable_bodies"):
			collision.collider.apply_central_impulse(-collision.normal * push)
#		if collision.collider.is_in_group('hurt_player'):
#			hurt_player()
	
func sleep():
	paused = true
	hide()

func end_game():
	Global.end_game()

func _on_Timer_timeout():
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if body.is_in_group('hurt_player'):
		die()
	pass # Replace with function body.
	
	
func shoot_ball():
	if time_shoot <= 0:
		var throw_vect = get_global_mouse_position() - Vector2(getCurrentCamera2D().get_camera_screen_center().x, position.y)
		var distance = throw_vect.x
		var ball = shoot_ball_scene.instance()
		throw_vect.y = -600
#		throw_vect.x = sign(throw_vect.x) * pow(abs(throw_vect.x), 1.2) / 5
		throw_vect.x = -distance / (throw_vect.y / ball.g_gravity) 
		ball.velocity = throw_vect
		if Input.is_action_pressed("walk_right"):
			ball.velocity.x += speed
		if Input.is_action_just_pressed("walk_left"):
			ball.velocity.x -= speed
		if _animation_sprite.flip_h:
			ball.position = position + Vector2(-40, 0)
		else:
			ball.position = position + Vector2(40, 0)
		
		get_parent().add_child(ball)
		time_shoot = shoot_diff
		
func set_checkpoint(checkpoint):
	Global.set_checkpoint(checkpoint.name)


func _on_Area2D_area_entered(area):
	if area.is_in_group('hurt_player'):
		die()
	pass

