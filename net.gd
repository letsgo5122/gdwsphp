extends Node

#------WS config start-------------------------------------
const Listen_PORT = 5122 
const PROTO_NAME = "Robin"
#onready var PORT = OS.get_environment("PORT")

#heroku server,Heroku websocketclient URL
var SERVER_IP = "gdwsphp.herokuapp.com"
var SERVER_PHP = "https://gdwsphp.herokuapp.com"
var CON2URL = "wss://" + SERVER_IP+ ":" + str("443")+ "/gd/"
#------WS config end----------------------------------------

#local:Docker container with nginx redirect to 127.0.0.1:5122
#var SERVER_IP = "127.0.0.1"
#var SERVER_PHP = "http://localhost"
#var CON2URL ="ws://" + "127.0.0.1"+ "/gd/"
#------WS config end----------------------------------------

var player_stats = {"name":"","score":0}
var players = {}
signal refreshList(players)
#signal serverState(player_name)

onready var args = Array(OS.get_cmdline_args())

func _ready():
	if OS.get_name()=="HTML5":
		OS.set_window_maximized(true)
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	if args.has("-s"):
		print("starting server...\n")
		serverStart()
	
func _player_connected(id):
	#print("player_connected =",id)
	pass
	
remote func register_player(new_id, player_stats):
	#var new_id = get_tree().get_rpc_sender_id()
	players[new_id] = player_stats
	#add_player(new_id)
	#print("register_player: ",player_stats,"   players: ",players)
	if get_tree().is_network_server():
		for idp in players:
			if idp != new_id :
				#send exist players to new_id 
				rpc_id(new_id,"register_player", idp, players[idp])
				#send new_id to all players
				if idp != 1:
					rpc_id(idp,"register_player", new_id, players[new_id])
				
	emit_signal("refreshList", players)
	
func _connected_ok():
	#Connected to server ok
	var player_id = get_tree().get_network_unique_id()
	players[player_id] = player_stats
	#add_player(player_id)
	rpc_id(1,"register_player",player_id, player_stats)
	print("_connected_ok ",player_id)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func join_game(new_player_name):
	player_stats["name"] = new_player_name
	var host = WebSocketClient.new()
	host.connect_to_url(CON2URL, PoolStringArray([PROTO_NAME]), true)
	get_tree().set_network_peer(host)

func serverStart():
	player_stats["name"] = "*Server*"
	var host = WebSocketServer.new()
	#Heroku Server:nginx proxy_pass to 5122 on Heroku Server 
	host.listen(Listen_PORT, PoolStringArray([PROTO_NAME]), true)
	print("Listen on SVR_PORT: ",Listen_PORT)
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().set_network_peer(host)
	#("serverState",player_stats)
	var player_id = get_tree().get_network_unique_id()
	players[player_id] = player_stats
	#add_player(player_id)
	#get_node("/root/lobby/CreateAccount/AccountPanel").visible=false
	emit_signal("refreshList", players)


func _player_disconnected(id):
	if get_tree().is_network_server():
		#print("_player_disconnected :",id)
		for p_id in players:
			if p_id != id  && p_id != 1:
				rpc_id(p_id,"unregister_player",id)
		unregister_player(id)
		
func _connected_fail():
	print("_connected_fail")
	
func _server_disconnected():
	emit_signal("game_error", "Server disconnected")
	get_tree().get_root().queue_free()

remote func unregister_player(id):
	#get_node("/root/world/players").get_node(str(id)).queue_free()
	players.erase(id)
	emit_signal("refreshList", players)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func startserver():
	print("net start server")
	serverStart()
	
func startclient(u_name):
	print("net start client")
	join_game(u_name)


#func rndSpawn():
#	var spawn = Vector2(rand_range(200, 600),rand_range(200, 500))
#	#print("spawn",spawn)
#	return spawn
#
#func rndVelocity():
#	var dir = randi() % 2
#	if dir == 0:
#		return Vector2(1,0)
#	else:
#		return Vector2(-1,0)
#
#func add_player(id):
#	#if id != 1:
#	#var player_scene= load("res://characters/player.tscn")
#	var player_scene= load("res://characters/hero.tscn")
#	#var player_gui = load("res://gui/GUI.tscn").instance()
#	#player_gui.set_name(str(id))
#	var player = player_scene.instance()
#	player.set_name(str(id))
#	player.setPlayerName(players[id]["name"])
#	player.set_network_master(id)
#	player.position = rndSpawn()

#remotesync func update_player_stats(id ,newscore):
#	players[id]["score"] = newscore
#	#print("update_player_stats:",players)
#
