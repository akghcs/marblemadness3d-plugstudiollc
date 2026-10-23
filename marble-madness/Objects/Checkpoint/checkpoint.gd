extends Node3D
class_name Checkpoint

@onready var marker: CSGCylinder3D = $Marker

var level_manager: LevelManager
var marker_material := StandardMaterial3D.new()


func _ready() -> void:
	level_manager = get_tree().get_first_node_in_group("level_manager")
	level_manager.checkpoint_reached.connect(_on_checkpoint_reached)
	marker.material = marker_material
	_set_active(false)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.owner.is_in_group("player"):
		level_manager.set_checkpoint(self)


func _on_checkpoint_reached(checkpoint: Node3D) -> void:
	_set_active(checkpoint == self)


func _set_active(active: bool) -> void:
	marker_material.emission_enabled = active
	if active:
		marker_material.albedo_color = Color(0.3, 1.0, 0.45)
		marker_material.emission = Color(0.2, 0.8, 0.3)
	else:
		marker_material.albedo_color = Color(0.45, 0.5, 0.65)
