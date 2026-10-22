extends Control
class_name PlayerHUD

@onready var ability_collected_label: Label = $AbilityCollectedLabel
@onready var coins_collected: Label = $CoinsCollectedLabel
var level_manager: LevelManager
var player : Player


func _ready() -> void:
	level_manager = get_tree().get_first_node_in_group("level_manager")
	level_manager.connect("coin_collected", _on_coin_collected)
	coins_collected.text = "Coins %s/%s" % [level_manager.coins_collected, level_manager.max_coins]
	
	player = get_tree().get_first_node_in_group("player")

func _on_coin_collected() -> void:
	coins_collected.text = "Coins %s/%s" % [level_manager.coins_collected, level_manager.max_coins]

func _process(delta: float) -> void:
	_update_current_ability_text()

func _update_current_ability_text() -> void:
	var marble : Marble = player.marble
	
	match marble.current_ability:
		Marble.ABILITIES.NONE:
			ability_collected_label.text = "Current Ability: None"
			
		Marble.ABILITIES.SPRING:
			ability_collected_label.text = "Current Ability: Spring"
			
		Marble.ABILITIES.PROPELLER:
			ability_collected_label.text = "Current Ability: Propeller"
	
