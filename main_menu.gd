extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_pressed():
	Global.start_game()
	pass # Replace with function body.


func _on_main_menu_hide():
	pass # Replace with function body.

func route(val):
	if val == 'main':
		$CanvasLayer/main.show()
		$CanvasLayer/settings.hide()
	elif val == 'settings':
		$CanvasLayer/main.hide()
		$CanvasLayer/settings.show()

func _on_main_menu_visibility_changed():
	if visible:
		$CanvasLayer/Sprite.visible = true
		$CanvasLayer/main.visible = true
		$CanvasLayer/settings.visible = false
	else:
		$CanvasLayer/Sprite.visible = false
		$CanvasLayer/main.visible = false
		$CanvasLayer/settings.visible = false
	pass # Replace with function body.


func _on_settings_back():
	route('main')
	pass # Replace with function body.


func _on_setting_button_pressed():
	route('settings')
	pass # Replace with function body.


func _on_godot_credit_pressed():
	OS.shell_open("https://godotengine.org/license")
	pass # Replace with function body.
