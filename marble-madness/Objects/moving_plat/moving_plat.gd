extends AnimatableBody3D
class_name moving_plat
@export var speed_plat : float = 20.0
@onready var finish: Marker3D = $finish
@onready var wait: Timer = $CSGBox3D/wait

var move_finish : bool = false
var start_plat : Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_plat = global_position
	finish.hide()
	wait.start()
	pass

func move_plat() -> void:
	var tween = create_tween() 
	if move_finish:
		tween.tween_property(self, "global_position", finish.global_position, speed_plat).set_ease(Tween.EASE_IN_OUT)
	else:
		tween.tween_property(self, "global_position", start_plat, speed_plat).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	wait.start()

func _on_wait_timeout() -> void:
	move_finish = !move_finish
	move_plat()
	pass # Replace with function body.
