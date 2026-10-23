extends Control
class_name PlayerHUD

@onready var ability_collected_label: Label = $AbilityCollectedLabel
@onready var coins_collected: Label = $CoinsCollectedLabel
@onready var timer_label: Label = $TimerLabel
var level_manager: LevelManager
var player : Player


func _ready() -> void:
	level_manager = get_tree().get_first_node_in_group("level_manager")
	level_manager.connect("coin_collected", _on_coin_collected)
	level_manager.time_changed.connect(_on_time_changed)
	coins_collected.text = "Coins %s/%s" % [level_manager.coins_collected, level_manager.max_coins]

	player = get_tree().get_first_node_in_group("player")

	timer_label.visible = level_manager.time_limit > 0.0
	_on_time_changed(level_manager.time_left)


func _on_coin_collected() -> void:
	coins_collected.text = "Coins %s/%s" % [level_manager.coins_collected, level_manager.max_coins]


func _on_time_changed(time_left: float) -> void:
	timer_label.text = "Time: %d" % ceili(time_left)
	# Turn red for the last 10 seconds (set explicitly both ways, the resource is shared).
	timer_label.label_settings.font_color = Color(1.0, 0.35, 0.35) if time_left <= 10.0 else Color.WHITE


func _process(_delta: float) -> void:
	_update_current_ability_text()


func _update_current_ability_text() -> void:
	var marble : Marble = player.marble
	var text := "Current Ability: None"

	match marble.current_ability:
		Marble.ABILITIES.SPRING:
			text = "Current Ability: Spring"

		Marble.ABILITIES.PROPELLER:
			var fuel_percent := 0
			if marble.propeller_fuel_seconds > 0.0:
				fuel_percent = roundi(100.0 * marble.propeller_fuel / marble.propeller_fuel_seconds)
			text = "Current Ability: Propeller %d%%" % fuel_percent

	if marble.current_ability != Marble.ABILITIES.NONE and marble.ability_duration > 0.0:
		text += "  %ds" % ceili(marble.ability_time_left)

	ability_collected_label.text = text
