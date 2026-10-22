extends RigidBody3D
class_name Marble

@export var movement_speed : float = 385.0 
@export var max_velocity : float = 7.5
@export var jump_power : float = 6.0
@export var finish_deceleration : float = 0.25

@onready var camera_3d = $"../Camera/HRotation/VRotation/SpringArm3D/Camera3D"

enum ABILITIES {
	NONE,
	SPRING,
	PROPELLER
}

var current_ability : ABILITIES = ABILITIES.NONE

var grounded = false
var can_move = true
var level_finished = false

func _physics_process(delta):
	
	if can_move:
		movement(delta)
	
	if level_finished:
		gravity_scale = move_toward(gravity_scale, 0.0, finish_deceleration * delta)
	if linear_velocity.x > max_velocity:
		linear_velocity.x = max_velocity
	if linear_velocity.x < -max_velocity:
		linear_velocity.x = -max_velocity
	if linear_velocity.z > max_velocity:
		linear_velocity.z = max_velocity
	if linear_velocity.z < -max_velocity:
		linear_velocity.z = -max_velocity
		
	if Input.is_action_just_pressed("Jump") and grounded:
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
	pass

func jump():
	apply_central_impulse(Vector3.UP * jump_power)


func _on_player_ability_collected(ability) -> void:
	current_ability = ability
	pass # Replace with function body.
