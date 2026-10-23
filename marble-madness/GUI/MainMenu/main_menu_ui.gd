extends Control

@onready var main_panel: Control = $base
@onready var options_screen: Control = $options_screen
@onready var level_select: Control = $level_select
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_show_only(main_panel)
	music_slider.value = AudioSettings.music_volume
	sfx_slider.value = AudioSettings.sfx_volume
	music_slider.value_changed.connect(AudioSettings.set_music_volume)
	sfx_slider.value_changed.connect(AudioSettings.set_sfx_volume)


# Only one of the three menu pages is visible at a time.
func _show_only(panel: Control) -> void:
	for p in [main_panel, options_screen, level_select]:
		p.visible = (p == panel)


func _on_play_pressed() -> void:
	_show_only(level_select)


func _on_options_pressed() -> void:
	_show_only(options_screen)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	AudioSettings.save_settings()
	_show_only(main_panel)


func _on_lvl_back_button_pressed() -> void:
	_show_only(main_panel)
