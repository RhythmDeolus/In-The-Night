extends Node2D

export (float) var angular_speed = 0

export (int) var velocity = 100

export (String) var type = "bg"

func _physics_process(delta):
	$".".rotation_degrees += delta * angular_speed
	while $".".rotation_degrees > 360:
		$".".rotation_degrees -= 360
	$".".position.y += velocity * delta
