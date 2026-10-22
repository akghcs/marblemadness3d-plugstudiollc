extends Control
class_name PlayerHUD

@onready var coins_collected: Label = $CoinsCollectedLabel
var level_manager: LevelManager


func _ready() -> void:
	level_manager = get_tree().get_first_node_in_group("level_manager")
	level_manager.connect("coin_collected", _on_coin_collected)
	coins_collected.text = "Coins %s/%s" % [level_manager.coins_collected, level_manager.max_coins]

func _on_coin_collected() -> void:
	coins_collected.text = "Coins %s/%s" % [level_manager.coins_collected, level_manager.max_coins]
