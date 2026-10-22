extends Node3D
class_name CameraContainer

@export_category("Fixed view")
@export var yaw_degrees : float = 45.0
@export var pitch_degrees : float = -28
@export var ortho_size : float = 5.0       # smaller = more zoomed in

@export_category("Follow")
@export var smooth_camera_tolerance : float = 0.15
@export var finish_rotation_speed : float = 25.0

var level_finished = false

@onready var marble = $"../Marble"
@onready var h_rotation = $HRotation
@onready var v_rotation = $HRotation/VRotation
@onready var camera_3d : Camera3D = $HRotation/VRotation/SpringArm3D/Camera3D

func _ready():
	camera_3d.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera_3d.size = ortho_size
	h_rotation.rotation_degrees.y = yaw_degrees
	v_rotation.rotation_degrees.x = pitch_degrees

func _physics_process(delta):
	global_position = global_position.lerp(
		marble.get_node("MeshInstance3D").global_position, smooth_camera_tolerance)

	if level_finished:
		h_rotation.rotation_degrees.y += finish_rotation_speed * delta
