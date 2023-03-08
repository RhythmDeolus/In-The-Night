extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("readying")
	if get_child_count():
		var n = randi() % get_child_count()
		get_child(n).disable_it()
		var i = 0
		while i < get_child_count():
			if i  != n:
				get_child(i).enable_it()
			i += 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
