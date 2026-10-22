extends Node3D




func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.owner.is_in_group("player"):
		var player : Player = body.owner
		get_tree().reload_current_scene()
