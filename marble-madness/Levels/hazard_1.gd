extends Area3D
class_name Hazard1

var level_manager: LevelManager

func _ready() -> void:
	level_manager = get_tree().get_first_node_in_group("level_manager")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		level_manager.respawn_player()
