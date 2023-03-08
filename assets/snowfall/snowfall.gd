extends Node2D
const snowflake = preload("res://assets/snowfall/snowflakes/s1.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var arr_snowflakes_bg = []
var arr_snowflakes_fg = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func getCurrentCamera2D():
	var viewport = get_viewport()
	if not viewport:
		return null
	var camerasGroupName = "__cameras_%d" % viewport.get_viewport_rid().get_id()
	var cameras = get_tree().get_nodes_in_group(camerasGroupName)
	for camera in cameras:
		if camera is Camera2D and camera.current and is_instance_valid(camera) :
			return camera
	return null

onready var camera = getCurrentCamera2D()
var t = 1
var margin = 200
var rect = {x = 1024, y = 600}

func _physics_process(delta):
	if not is_instance_valid(camera):
		camera = getCurrentCamera2D()
		if not is_instance_valid(camera):
			return
	if t > 0.5:
		var s = snowflake.instance()
		s.angular_speed = rand_range(0, 30)
		var size = rand_range(0.045, 0.05)
		s.scale = Vector2(size, size)
		s.get_node("AnimatedSprite").frame = randi() % 2
		s.z_index = 100
		s.position = Vector2(rand_range(-margin + camera.get_camera_position().x, camera.get_camera_position().x + rect.x +  margin), -margin)
		s.type = "fg"
		$".".add_child(s)
		
		s = snowflake.instance()
		s.angular_speed = rand_range(0, 30)
		size = rand_range(0.025, 0.03)
		s.scale = Vector2(size, size)
		s.get_node("AnimatedSprite").frame = randi() % 2
		s.z_index = -100
		s.position = Vector2(rand_range(-margin + camera.get_camera_position().x, camera.get_camera_position().x + rect.x +  margin), -margin)
		s.type = "bg"
		$".".add_child(s)
		t = 0
	else:
		t += delta
	var cam_pos
	if getCurrentCamera2D():
		camera = getCurrentCamera2D()
	if is_instance_valid(camera):
		cam_pos = camera.get_camera_screen_center()
	for i in self.get_children():
		if i.type == "bg" and i.position.y > 540:
			i.queue_free()
		elif i.type == "fg" and i.position.y > 600:
			i.queue_free()
		if (camera):
			var rel_diff = i.position - cam_pos
			if abs(rel_diff.x) >= rect.x/2 + margin or abs(rel_diff.y) >= rect.y / 2:
				while i.position.x > cam_pos.x + rect.x / 2 + margin:
					i.position.x -= rect.x + 2 * margin
				while i.position.x < cam_pos.x - rect.x /2 - margin:
					i.position.x += rect.x + 2 * margin
				while i.position.y > cam_pos.y + rect.y / 2 + margin:
					i.position.y -= rect.y + 2 * margin
				while i.position.y < cam_pos.y - rect.y /2 - margin:
					i.position.y += rect.y + 2 * margin
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pas
