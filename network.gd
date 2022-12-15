extends Node

var port = 5555
var peer = NetworkedMultiplayerENet.new()

func join(host_ip):
	peer.connect("connection_failed", self, "on_connection_failed")
	peer.connect("connection_succeeded", self, "on_connection_succeeded")
	peer.create_client(host_ip, 5555)
	get_tree().network_peer = peer
	
func host():
	peer.connect("peer_connected", self, "on_peer_connected")
	peer.connect("peer_disconnected", self, "on_peer_disconnected")
	peer.create_server(port, 2)
	get_tree().network_peer = peer
	
func on_connection_failed():
	pass
	
func on_connection_succeeded():
	Events.emit_signal("player_joined", 1)
	Events.emit_signal("player_joined", get_tree().get_network_unique_id())
	pass
	
func on_peer_connected(who):
	Events.emit_signal("player_joined", who)
	pass
	
func on_peer_disconnected(_who):
	pass

remotesync func change_scene(s):
	Events.emit_signal("scene_change_request", s)
