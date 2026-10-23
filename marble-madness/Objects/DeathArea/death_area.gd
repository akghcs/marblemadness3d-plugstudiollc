extends Node3D

var level_manager: LevelManager


func _ready() -> void:
	level_manager = get_tree().get_first_node_in_group("level_manager")


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.owner.is_in_group("player"):
		level_manager.respawn_player()
