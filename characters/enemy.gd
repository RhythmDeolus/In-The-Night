extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (int) var speed = 0
# Called when the node enters the scene tree for the first time.
#
#var can_move = true
#
#onready var initial_pos = position

func _ready():
	pass # Replace with function body.

func _physics_process(delta):

#	for i in get_colliding_bodies():
#		if i.get_collision_layer_bit(0):
#			print("yayy")
#			speed *= -1
	position.x += speed * delta
	if not $RayCast2D.is_colliding() or not $RayCast2D2.is_colliding():
		speed *= -1
		position.x += speed * delta * 2
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func destroy():
	queue_free()


#func _on_VisibilityNotifier2D_screen_entered():
#	can_move = true
#	pass # Replace with function body.
#
#func reset():
#	var t = position
#	position = initial_pos
#	if $VisibilityNotifier2D.is_on_screen():
#		position = t
#	else:
#		can_move = false
#
#func _on_VisibilityNotifier2D_screen_exited():
#	reset()
#	pass # Replace with function body.

func _on_Area2D_area_entered(area):
	speed *= -1
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	speed *= -1
	pass # Replace with function body.
