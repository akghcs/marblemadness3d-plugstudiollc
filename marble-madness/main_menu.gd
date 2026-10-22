extends Control
class_name main_menu
@onready var base: Control = $base
@onready var options_screen: Control = $options_screen


func _ready() -> void:
	options_screen.hide()
	base.show()
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/level_one.tscn")
	pass # Replace with function body.


func _on_options_pressed() -> void:
	base.hide()
	options_screen.show()
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_back_pressed() -> void:
	options_screen.hide()
	base.show()
	pass # Replace with function body.
