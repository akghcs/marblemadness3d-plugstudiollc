extends Node
class_name LevelManager

signal level_finished
signal coin_collected
signal player_respawned
signal checkpoint_reached(checkpoint : Node3D)
signal time_changed(time_left : float)
signal time_up

## Seconds the player has to finish the level. 0 = no time limit.
@export var time_limit : float = 80.0
## Scene that the "Continue" button on the win screen loads. Leave empty on the last level.
@export_file("*.tscn") var next_level_path : String = ""

@onready var pause_menu: Control = $"../CanvasLayer/pause_menu"


var coins_collected : int = 0
var max_coins : int

var spawn_location : Vector3

var time_left : float = 0.0
## True once the level was finished or the time ran out.
var is_over : bool = false

@onready var player: Player = %Player
@onready var coins: Node3D = %Coins


func _ready() -> void:
	max_coins = coins.get_child_count()
	spawn_location = player.global_position
	time_left = time_limit
	level_finished.connect(_on_level_finished)
	get_tree().paused = false


func _process(delta: float) -> void:
	if is_over or time_limit <= 0.0:
		return

	time_left = maxf(time_left - delta, 0.0)
	time_changed.emit(time_left)

	if time_left <= 0.0:
		is_over = true
		player.marble.can_move = false
		time_up.emit()


func _on_level_finished() -> void:
	is_over = true


func _on_coin_collected() -> void:
	coins_collected += 1


func set_checkpoint(checkpoint: Node3D) -> void:
	var new_spawn := checkpoint.global_position + Vector3.UP * 1.0
	if new_spawn.is_equal_approx(spawn_location):
		return
	spawn_location = new_spawn
	checkpoint_reached.emit(checkpoint)


func respawn_player() -> void:
	var marble: Marble = player.marble
	marble.linear_velocity = Vector3.ZERO
	marble.angular_velocity = Vector3.ZERO
	marble.global_position = spawn_location
	


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause menu"):
		pause_menu.show()
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
