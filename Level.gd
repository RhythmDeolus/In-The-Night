extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer2/AnimationPlayer.play("start")
	$player/Camera2D2.make_current()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass # Replace with function body.

var player_died = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_checkpoint(name):
	if name:
		var checkpt = $checkpoints.get_node(name)
		print('setting up ', checkpt)
		if checkpt:
			$player.position = checkpt.position
			
func get_data():
	return $player._has_gun
func set_data(data):
	$player._has_gun = data

func _physics_process(delta):
	if Global.game_has_paused:
		return
	if Input.is_action_just_pressed("esc_menu"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Global.pause_game()
	if player_died and not $CanvasLayer2/AnimationPlayer.is_playing():
		Global.goto_checkpoint_lvl()
func end_scene():
	print('ending scene')
	$CanvasLayer2/AnimationPlayer.play('end')
	player_died = true
	
func credit_scene():
	$CanvasLayer2/AnimationPlayer.play('credit')
	
func exit_game():
	Global.exit_game()
	

func _on_Level_visibility_changed():
	if visible:
		$CanvasLayer/Sprite.visible = true
	else:
		$CanvasLayer/Sprite.visible = false
	pass # Replace with function body.
