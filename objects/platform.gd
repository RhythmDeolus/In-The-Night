extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int, -360, 360) var angular_speed = 0
export (Vector2) var translation_vect = Vector2.ZERO
export (int) var translation_speed = 0
export (float, -1, 1) var start_pos = 0
export (bool) var move_on_contact = false

onready var initial_pos = position
onready var initial_move_on_contact = move_on_contact

onready var  absolute_pos = position - start_pos * translation_vect
# Called when the node enters the scene tree for the first time.
var t =  position

func _ready():
	constant_linear_velocity = translation_vect.normalized() * translation_speed
	pass # Replace with function body.

func _physics_process(delta):
	if not visible:
		if $VisibilityNotifier2D.is_on_screen():
			position = t
		else:
			move_on_contact = initial_move_on_contact
		visible = true
	if move_on_contact:
		return
	rotate(delta * angular_speed * (PI /180))
	var t_vect = translation_vect.normalized() * delta * translation_speed
	
	if translation_vect.length() < (position - absolute_pos + t_vect).length():
		var t = t_vect
		t_vect -= translation_vect - (position - absolute_pos)
		t_vect *= -1
		t += 2 * t_vect
		t_vect = t
		translation_vect *= -1
		constant_linear_velocity = translation_vect.normalized() * translation_speed
	translate(t_vect)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.is_in_group('player'):
		move_on_contact = false


func reset():
	t = position
	position = initial_pos
	visible = false
	

func _on_VisibilityNotifier2D_screen_exited():
	reset()
	pass # Replace with function body.
