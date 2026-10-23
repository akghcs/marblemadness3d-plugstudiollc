extends Node3D
class_name FinishPoint

var level_manager: LevelManager


func _ready() -> void:
	level_manager = get_tree().get_first_node_in_group("level_manager")


func _on_finish_area_body_entered(body: Node3D) -> void:
	# Too late: the timer already ran out.
	if level_manager.is_over:
		return

	if body.owner.is_in_group("player"):
		var player : Player = body.owner
		player.level_finished.emit()

		level_manager.level_finished.emit()
