extends KinematicBody
class_name Controllable

var velocity = Vector3.ZERO
var turn_speed = 0.04
var move_speed = 20
var gravity = Vector3.DOWN * 9
var force = Vector3.ZERO

onready var body = $Armature

func move():
	#movement will always be rotated to your facing, force will not
	var v = velocity.rotated(Vector3.UP, body.rotation.y) * move_speed
	var _discard = move_and_slide(v + gravity + force)
	
func get_wasd():
	var wasd = Vector3.ZERO
	wasd.z = Input.get_action_strength("S") - Input.get_action_strength("W")
	wasd.x = Input.get_action_strength("A") - Input.get_action_strength("D")
	return wasd
	
func controls():
	var wasd = get_wasd()
	velocity = Vector3(0, 0, -wasd.z)
	key_turn()

func key_turn():
	var wasd = get_wasd()
	if wasd.x != 0:
		body.rotate(Vector3.UP, turn_speed * wasd.x)
