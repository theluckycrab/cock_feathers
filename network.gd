extends Node

var port = 5555
var ip = "127.0.0.1"

var peer = NetworkedMultiplayerENet.new()

func join():
	get_tree().network_peer = peer
	peer.connect("connection_failed", self, "on_connection_failed")
	peer.connect("connection_succeeded", self, "on_connection_succeeded")
	peer.create_client(ip, 2)
	
func host():
	get_tree().network_peer = peer
	peer.connect("peer_connected", self, "on_peer_connected")
	peer.connect("peer_disconnected", self, "on_peer_disconnected")
	peer.create_server(port, 2)
	
func on_connection_failed():
	pass
	
func on_connection_successful():
	pass
	
func on_peer_connected(_who):
	pass
	
func on_peer_disconnected(_who):
	pass
