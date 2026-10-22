extends Node3D
class_name Player

signal level_finished
signal ability_collected(ability : Marble.ABILITIES)
@onready var marble: Marble = $Marble
@onready var camera: CameraContainer = $Camera



func _on_level_finished() -> void:
		camera.smooth_camera_tolerance = 0.01
		camera.level_finished = true
		marble.can_move = false
		marble.level_finished = true
