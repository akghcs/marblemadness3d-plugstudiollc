extends RigidBody3D
class_name Marble

enum ABILITIES {
	NONE,
	SPRING,
	PROPELLER
}

signal ability_changed(ability : ABILITIES)

@export_category("Movement")
@export var movement_speed : float = 385.0
@export var max_velocity : float = 7.5
@export var jump_power : float = 6.0
@export var finish_deceleration : float = 0.25

@export_category("Abilities")
## Seconds an ability lasts once collected. 0 = it lasts until you die or collect another one.
@export var ability_duration : float = 0.0

@export_group("Spring")
## While the Spring is active, the jump is this many times stronger.
@export var spring_jump_multiplier : float = 1.6

@export_group("Propeller")
## Seconds of flight per jump. The fuel refills as soon as the marble touches the ground.
@export var propeller_fuel_seconds : float = 2.5
## Vertical speed while hovering. Small and positive = a slow drift upwards.
@export var propeller_climb_speed : float = 0.4
## How quickly the propeller cancels the fall.
@export var propeller_acceleration : float = 40.0

@onready var camera_3d = $"../Camera/HRotation/VRotation/SpringArm3D/Camera3D"
@onready var marble_mesh : MeshInstance3D = $MeshInstance3D

var grounded = false
var can_move = true
var level_finished = false

var ability_time_left : float = 0.0
var propeller_fuel : float = 0.0
var marble_material : StandardMaterial3D

var current_ability : ABILITIES = ABILITIES.NONE:
	set(value):
		current_ability = value
		ability_time_left = ability_duration
		propeller_fuel = propeller_fuel_seconds
		_update_ability_visual()
		ability_changed.emit(value)


func _ready() -> void:
	propeller_fuel = propeller_fuel_seconds
	# Work on our own copy of the material so tinting the marble never leaks into other scenes.
	var material = marble_mesh.get_surface_override_material(0)
	if material is StandardMaterial3D:
		marble_material = material.duplicate()
		marble_mesh.set_surface_override_material(0, marble_material)


func _physics_process(delta):

	if can_move:
		movement(delta)

	if level_finished:
		gravity_scale = move_toward(gravity_scale, 0.0, finish_deceleration * delta)

	_update_ability(delta)

	# Limit the speed on the ground plane (a single limit, so diagonals aren't faster).
	var flat_velocity := Vector2(linear_velocity.x, linear_velocity.z).limit_length(max_velocity)
	linear_velocity.x = flat_velocity.x
	linear_velocity.z = flat_velocity.y

	if can_move and Input.is_action_just_pressed("Jump") and grounded:
		jump()


func movement(delta):
	var cam_basis = camera_3d.global_transform.basis

	var forward = -cam_basis.z
	forward.y = 0
	forward = forward.normalized()

	var right = cam_basis.x
	right.y = 0
	right = right.normalized()

	var input_forward = Input.get_action_strength("Forward") - Input.get_action_strength("Back")
	var input_right = Input.get_action_strength("Right") - Input.get_action_strength("Left")

	var direction = (forward * input_forward + right * input_right).limit_length(1.0)
	apply_central_force(direction * movement_speed * delta)


func jump() -> void:
	var power := jump_power
	if current_ability == ABILITIES.SPRING:
		power *= spring_jump_multiplier
	apply_central_impulse(Vector3.UP * power)


func _update_ability(delta: float) -> void:
	if grounded:
		propeller_fuel = propeller_fuel_seconds

	if current_ability == ABILITIES.NONE:
		return

	if ability_duration > 0.0:
		ability_time_left -= delta
		if ability_time_left <= 0.0:
			current_ability = ABILITIES.NONE
			return

	if current_ability == ABILITIES.PROPELLER:
		_propeller(delta)


# Hold Jump while in the air: the propeller cancels the fall and lets the marble hover.
# It only kicks in once the marble is no longer rising faster than the hover speed, so the
# normal jump arc is never cut short.
func _propeller(delta: float) -> void:
	var active : bool = (
		can_move
		and Input.is_action_pressed("Jump")
		and not grounded
		and propeller_fuel > 0.0
		and linear_velocity.y < propeller_climb_speed
	)
	if not active:
		return

	propeller_fuel = maxf(propeller_fuel - delta, 0.0)
	linear_velocity.y = move_toward(linear_velocity.y, propeller_climb_speed, propeller_acceleration * delta)


func _update_ability_visual() -> void:
	if marble_material == null:
		return
	match current_ability:
		ABILITIES.SPRING:
			marble_material.albedo_color = Color(0.55, 1.0, 0.55)
		ABILITIES.PROPELLER:
			marble_material.albedo_color = Color(0.55, 0.8, 1.0)
		_:
			marble_material.albedo_color = Color.WHITE


# Teleport back to a spawn point: stop all movement and lose the current ability.
func respawn(spawn_position: Vector3) -> void:
	global_position = spawn_position
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	current_ability = ABILITIES.NONE


func _on_player_ability_collected(ability) -> void:
	current_ability = ability
