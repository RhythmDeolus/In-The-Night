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
func route(val):
	if val == 'main':
		$CanvasLayer/main.show()
		$CanvasLayer/settings.hide()
	elif val == 'settings':
		$CanvasLayer/main.hide()
		$CanvasLayer/settings.show()

func _on_esc_menu_visibility_changed():
	if visible:
		$CanvasLayer/main.visible = true
		$CanvasLayer/settings.visible = false
		$CanvasLayer/ColorRect.visible = true
	else:
		$CanvasLayer/main.visible = false
		$CanvasLayer/settings.visible = false
		$CanvasLayer/ColorRect.visible = false
	pass # Replace with function body.


func _on_Button_pressed():
	Global.resume_game()
	pass # Replace with function body.


func _on_Button3_pressed():
	Global.exit_game()
	pass # Replace with function body.


func _on_Button2_pressed():
	route('settings')
	pass # Replace with function body.


func _on_settings_back():
	route('main')
	pass # Replace with function body.
