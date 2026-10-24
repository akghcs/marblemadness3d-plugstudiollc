extends Control
class_name YouWinScreen

@onready var title_label: Label = %YouWinLabel
@onready var coins_collected_label: Label = %CoinsCollectedLabel
@onready var time_label: Label = %TimeLabel
@onready var continue_button: Button = %ContinueButton
@export var level_scene : PackedScene

var level_manager: LevelManager


func _ready() -> void:
	level_manager = get_tree().get_first_node_in_group("level_manager")
	level_manager.connect("level_finished", _on_level_finished)
	level_manager.connect("time_up", _on_time_up)


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_packed(level_scene)
	# No next level set on this level: go back to the menu.
	#if level_manager.next_level_path.is_empty():
		#get_tree().change_scene_to_file("res://GUI/MainMenu/main_menu.tscn")
	#else:
		#get_tree().change_scene_to_file(level_manager.next_level_path)


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://GUI/MainMenu/main_menu.tscn")


func _on_level_finished() -> void:
	if level_scene == null:
		continue_button.hide() 
	title_label.text = "You Win"
	time_label.visible = level_manager.time_limit > 0.0
	time_label.text = "Time left: %.1f s" % level_manager.time_left
	_show_screen()
	print(level_scene)

func _on_time_up() -> void:
	title_label.text = "Time's Up!"
	continue_button.visible = false
	time_label.visible = true
	time_label.text = "You ran out of time"
	_show_screen()


func _show_screen() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true
	coins_collected_label.text = "Coins %s/%s" % [level_manager.coins_collected, level_manager.max_coins]

	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,-1000), 0)
	tween.tween_property(self, "position", Vector2(0,0), .5)
