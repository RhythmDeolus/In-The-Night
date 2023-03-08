extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float) var size = 1
export (bool) var is_increasable = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
#
##var last_pos = position
##func _physics_process(delta):
##	if linear_velocity.y == 0:
##		size += linear_velocity.x * 0.0001
##		scale = Vector2(size, size)
##	last_pos = position
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
