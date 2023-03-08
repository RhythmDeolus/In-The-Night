extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var speed = 0
export (int) var destroy_after = 60
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func destroy():
	queue_free()

var time_passed = 0
func _physics_process(delta):
	position.x += speed * delta
	
	time_passed += delta
	if time_passed > destroy_after:
		destroy()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func disable_it():
	hide()
	$CollisionShape2D.disabled = true
func enable_it():
	show()
	$CollisionShape2D.disabled = false
