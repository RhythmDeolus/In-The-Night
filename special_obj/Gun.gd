extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
export var has_gotten = false

func _ready():
	if has_gotten:
		show_instruction()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func show_instruction():
	$after.show()
	$before.hide()

func _on_gun_body_entered(body):
	if body.is_in_group('player'):
		body._has_gun = true
		has_gotten = true
		show_instruction()
