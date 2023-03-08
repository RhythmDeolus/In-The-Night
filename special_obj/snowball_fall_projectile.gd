extends Area2D

var g_gravity = 20
var velocity = Vector2.ZERO
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var wait_time = 2
var delete_after = 20

onready var animation_player = $AnimationPlayer

var status = 'alive'
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var t = 0
func _physics_process(delta):
	if t < delete_after:
		t += delta
	else:
		queue_free()
	if wait_time > 0:
		wait_time -= delta
	else:
		if status == 'alive':
			velocity.y += g_gravity
			position += delta * velocity

func play_animation(val = 'alive'):
	animation_player.play(val)

func _on_Area2D_area_entered(area):
	if status == 'alive':
		status = 'exploding'
		animation_player.play('explode')
	pass # Replace with function body.



func _on_Area2D_body_entered(body):
	if status == 'alive':
		status = 'exploding'
		animation_player.play('explode')
	pass # Replace with function body.
