extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var music_slider = $VBoxContainer2/HBoxContainer/HSlider
onready var fullscreen_checkbutton = $VBoxContainer2/HBoxContainer3/CheckBox
signal back

# Called when the node enters the scene tree for the first time.
func _ready():
	music_slider.value = Global.get_music_volume()
	fullscreen_checkbutton.pressed = OS.window_fullscreen
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_HSlider_value_changed(value):
	Global.set_music_volume(value)
	pass # Replace with function body.

func _on_TextureButton_pressed():
	emit_signal("back")
	pass # Replace with function body.


func _on_CheckBox_toggled(button_pressed):
	if OS.window_fullscreen != button_pressed: 
		OS.window_fullscreen = button_pressed
	pass # Replace with function body.


func _on_settings_visibility_changed():
	_ready()
	pass # Replace with function body.
