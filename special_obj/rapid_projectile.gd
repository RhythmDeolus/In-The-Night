extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var has_been_shot = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
export var velocity = Vector2.ZERO
var delete_after = 10

var t = 0
func _physics_process(delta):
	if has_been_shot:
		if t > delete_after:
			queue_free()
		t += delta
		position += velocity * delta
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func shoot():
	has_been_shot = true
