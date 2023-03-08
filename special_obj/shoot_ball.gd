extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var g_gravity = 1300
export (Vector2) var velocity = Vector2(2, -3).normalized() * 1500
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var t = 0

func _physics_process(delta):
	velocity.y += g_gravity * delta
	position += velocity * delta
	t += delta
	if t > 5:
		queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_shoot_ball_body_entered(body):
	if body.is_in_group('enemy'):
		if body.has_method('destroy'):
			body.destroy()
		else:
			body.queue_free()
		queue_free()
	pass # Replace with function body.
