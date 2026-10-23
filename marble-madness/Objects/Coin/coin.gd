extends Node3D

class_name Coin

@export var spin_rate : float = 1

var level_manager: LevelManager
var collected := false

@onready var coin_mesh: Node3D = $CoinMesh
@onready var area: Area3D = $Area3D
@onready var sound: AudioStreamPlayer = $CoinSound

func _ready() -> void:
	level_manager = get_tree().get_first_node_in_group("level_manager")

func _physics_process(_delta: float) -> void:
	coin_mesh.rotation_degrees.y += spin_rate

func _on_area_3d_body_entered(body: Node3D) -> void:
	if collected or not body.owner.is_in_group("player"):
		return
	collected = true

	level_manager.emit_signal("coin_collected")

	# Hide the coin and stop detecting, but keep the node alive for the sound
	coin_mesh.hide()
	area.set_deferred("monitoring", false)
	set_physics_process(false)

	if sound.stream:
		sound.play()
		await sound.finished
	queue_free()
