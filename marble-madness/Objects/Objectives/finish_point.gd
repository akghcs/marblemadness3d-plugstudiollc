extends Node3D
class_name FinishPoint

@onready var level_manager: LevelManager = %LevelManager


func _on_finish_area_body_entered(body: Node3D) -> void:
	if body.owner.is_in_group("player"):
		var player : Player = body.owner
		player.level_finished.emit()
		
		level_manager.level_finished.emit()
	pass
