extends Node

var main_menu_scene = preload('res://main_menu.tscn')
var level_scene = preload('res://Level.tscn')
var esc_menu_scene = preload('res://esc_menu.tscn')
var music_player_scene = preload("res://musicplayer.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var main_menu = add_scene_to_tree(main_menu_scene.instance())
onready var level = null
onready var esc_menu = add_scene_to_tree(esc_menu_scene.instance())
onready var music_player = add_scene_to_tree(music_player_scene.instance())
#onready var main_menu = get_tree().get_root().get_child(0).get_node('main_menu')


var game_has_started = false
var game_has_paused = true
var game_has_completed = false

var level_checkpoint = null
var saved_data = null

func start_game():
	if not main_menu:
		return
	level = add_scene_to_tree(level_scene.instance())
	set_checkpoint()
	show(level)
	game_has_started = true
	game_has_paused = false
	get_tree().paused = false
	music_player.play_music('main_level')
# Called when the node enters the scene tree for the first time.

func show(val):
	if val:
		if main_menu: main_menu.hide()
#		if level: level.hide()
		if esc_menu: esc_menu.hide()
		val.show()

func pause_game():
	if game_has_started and not game_has_paused:
		game_has_paused = true
		get_tree().paused = true
		show(esc_menu)
		
func resume_game():
	if game_has_started and game_has_paused:
		game_has_paused = false
		get_tree().paused = false
		show(level)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func set_checkpoint(val = null):
	if level: 
		level_checkpoint = val
		saved_data = level.get_data()

func go_to_checkpoint():
	level.end_scene()
	
func goto_checkpoint_lvl():
	main_menu.get_node('Camera2D').make_current()
	level.queue_free()
	level = add_scene_to_tree(level_scene.instance())
	level.set_checkpoint(level_checkpoint)
	level.set_data(saved_data)
	music_player.play_music('main_level')
	
func end_game():
	game_has_completed = true
	if level: level.credit_scene()

func exit_game():
	show(main_menu)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if level: level.queue_free()
	game_has_started = false
	game_has_paused = true
	main_menu.get_node('Camera2D').make_current()
	music_player.play_music('main_menu')

func _ready():
	if not main_menu:
		return
	print(get_tree().get_root().get_child(0))
	print(main_menu, level)
	show(main_menu)
	music_player.start_with('main_menu')
	get_tree().paused = true
	pass # Replace with function body.

func add_scene_to_tree(node):
	get_tree().get_root().get_child(1).add_child(node)
	return node
	
func remove_scene_from_tree(node):
	if node: get_tree().get_root().get_child(1).remove_child(node)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	
func boss_battle_music_start():
	music_player.play_music('boss_music')

func boss_battle_music_end():
	music_player.play_music('main_level')
	
func stop_music():
	music_player.stop_music()

func set_music_volume(val):
	if val >=0 and val <= 100: 
		music_player.set_volume(val)
		
func get_music_volume():
	return music_player.get_volume()
