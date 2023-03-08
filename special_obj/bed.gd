extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var is_active = false
var player = null
onready var animation_player = $AnimationPlayer
var game_completed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var t = 0
var t_diff = 5
var called_end_game = false
func _physics_process(delta):
	if game_completed and not called_end_game:
		t += delta
		if t > t_diff:
			player.end_game()
			called_end_game = true
		return
	if is_active:
		if Input.is_action_just_pressed("interact"):
			if player:
				$active.hide()
				animation_player.play("sleeping")
				game_completed = true
				player.sleep()


func _on_Area2D_body_entered(body):
	if body.is_in_group('player'):
		is_active = true
		$active.show()
		player = body
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if body.is_in_group('player'):
		is_active = false
		$active.hide()
		player = null
	pass # Replace with function body.
