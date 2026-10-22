extends Node
class_name LevelManager

signal level_finished 
signal coin_collected

var coins_collected : int = 0
var max_coins : int

var spawn_location : Vector3
@onready var player: Player = %Player
@onready var coins: Node3D = %Coins


func _ready() -> void:
	max_coins = coins.get_child_count()
	spawn_location = player.global_position


func _on_coin_collected() -> void:
	coins_collected += 1
	pass
	
