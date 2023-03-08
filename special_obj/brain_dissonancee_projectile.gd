extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var velocity = Vector2.ZERO
var delete_after = 10
var shoot_time = 1
var has_shot = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var t = 0
func _physics_process(delta):
	if not has_shot and t > shoot_time :
		has_shot = true
	if has_shot and t > delete_after:
		queue_free()
	t += delta
	if has_shot:
		position += velocity * delta
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
