extends Node3D

class_name AbilityCollectable

@export var ability : Marble.ABILITIES
## Degrees per second.
@export var spin_speed : float = 90.0
@export var bob_height : float = 0.15

@onready var corkscrew: Node3D = $Corkscrew
@onready var propeller: Node3D = $Propeller
@onready var collection_area: Area3D = $CollectionArea

var level_manager: LevelManager
var collected : bool = false
var base_y : float
var time : float = 0.0


func _ready() -> void:
	corkscrew.hide()
	propeller.hide()

	match ability:
		Marble.ABILITIES.SPRING:
			corkscrew.show()
		Marble.ABILITIES.PROPELLER:
			propeller.show()

	base_y = position.y

	# When the player dies the pickup comes back, so the level can never be soft-locked.
	level_manager = get_tree().get_first_node_in_group("level_manager")
	if level_manager:
		level_manager.player_respawned.connect(_on_player_respawned)


func _process(delta: float) -> void:
	if collected:
		return
	time += delta
	rotation_degrees.y += spin_speed * delta
	position.y = base_y + sin(time * 2.0) * bob_height


func _on_collection_area_body_entered(body: Node3D) -> void:
	if collected:
		return
	if body.owner and body.owner.is_in_group("player"):
		var player : Player = body.owner
		player.ability_collected.emit(ability)
		_set_collected(true)


func _on_player_respawned() -> void:
	_set_collected(false)


func _set_collected(value: bool) -> void:
	collected = value
	visible = not value
	collection_area.set_deferred("monitoring", not value)
