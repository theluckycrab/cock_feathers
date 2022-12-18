extends KinematicBody
class_name Controllable

var velocity = Vector3.ZERO
var turn_speed = 0.4
var move_speed = 30
var gravity = Vector3.DOWN * 9
var force = Vector3.ZERO
var mouse_relative_x = 0
var net_owner = 1
var active = false

onready var body = $Armature

func move(delta):
	#movement will always be rotated to your facing, force will not
	if ! active:
		velocity = Vector3.ZERO
	var v = velocity.normalized().rotated(Vector3.UP, body.rotation.y) * move_speed
	var _discard = move_and_slide(v + gravity + force)
	body.rotate(Vector3.UP, mouse_relative_x * turn_speed * delta)
	mouse_relative_x = 0
	if active and net_owner == get_tree().get_network_unique_id():
		send_move_data()
	
func get_wasd():
	var wasd = Vector3.ZERO
	wasd.z = Input.get_action_strength("S") - Input.get_action_strength("W")
	wasd.x = Input.get_action_strength("D") - Input.get_action_strength("A")
	return wasd
	
func controls():
	if !active or net_owner != get_tree().get_network_unique_id():
		return
	var wasd = get_wasd()
	velocity = Vector3(wasd.x, 0, wasd.z)
	#key_turn()
	#mouse_turn()

func key_turn():
	var wasd = get_wasd()
	if wasd.x != 0:
		body.rotate(Vector3.UP, turn_speed * wasd.x)

func send_move_data():
	var move_data = {}
	move_data["position"] = global_transform.origin
	move_data["rotation"] = body.rotation.y
	rpc("sync_move_data", move_data)
	pass
	
remote func sync_move_data(m):
	global_transform.origin = m.position
	body.rotation.y = m.rotation
	pass

func set_active(a):
	active = a
	if a and net_owner == get_tree().get_network_unique_id():
		$Armature/Camera.current = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
func _input(event):
	if !active or get_tree().get_network_unique_id() != net_owner:
		return
	else:
		if event is InputEventMouseMotion:
			mouse_relative_x = -event.relative.x
