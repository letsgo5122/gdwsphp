extends Node
onready var u_name = $CreateAccount/AccountPanel/UserNameEdit
onready var u_password = $CreateAccount/AccountPanel/passwordEdit
onready var acc_list = $CreateAccount/AccountPanel/AccountList
onready var chat_list = $CreateAccount/AccountPanel/ChatList
onready var chat_edit = $CreateAccount/AccountPanel/ChatEdit
var act = ""
var url = net.SERVER_PHP+"/"+"gdapi.php"

func _ready():
	net.connect("refreshList", self, "listConnectedUser")
	pass # Replace with function body.
	
func _on_Create_pressed():
	var trimname = u_name.text.strip_edges(true,true)
	var trimpass = u_password.text.strip_edges(true,true)
	if trimname != "" && trimpass != "":
		#post json
		act = "insert"
		post_query(act, trimname, trimpass)
	else:
		acc_list.text = "Please Enter User Name And Password."

func _on_Login__pressed():
	#print("loginpress")
	var trimname = u_name.text.strip_edges(true,true)
	var trimpass = u_password.text.strip_edges(true,true)
	#print("user",trimname,trimpass)
	if trimname != "" && trimpass != "":
		#post json
		act = "listUser"
		post_query(act, trimname, trimpass)
	else:
		acc_list.text = "Wrong User Name Or Password."
	

func post_query(act, trimname, trimpass):
	var data_to_send = {"act":act,"name":trimname,"passwd":trimpass}
	var query = JSON.print(data_to_send)
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	var error = $HTTPPost.request(url, headers, false, HTTPClient.METHOD_POST, query)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _on_HTTPPost_request_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200 :
			#print(body.get_string_from_utf8())
			var json = JSON.parse(body.get_string_from_utf8())
			#print(json.result)
			match act:
				"listUser":
					#print("listuser")
					act_listUser(json.result)
				"insert":
					#print("insert")
					act_insert(json.result)

		else:
			acc_list.text = "err code:"+str(response_code)

func act_listUser(result):
	if result != null:
		net.callv("startclient",[str(result[0]['name'])])
		#print("result:",result)
		chat_list.append_bbcode("Name: "+str(result[0]['name'])+" Login Successul!"+"\n")

	else:
		chat_list.text = "Wrong user name or password."


func act_insert(result):
	if result != null:
		acc_list.text = ""
		acc_list.append_bbcode("ID:"+str(result[0]['id'])+"  Name:"+result[0]['name']+" Create Successul!")
	else:
		acc_list.text = "Username Already Exist."
	pass
	

func listConnectedUser(players):
	#print(players.keys())
	#print(players)
	acc_list.text = ""
	for id in players.keys():
		if "name" in players[id]:
			#print(players[id]["name"])
			acc_list.append_bbcode(str(players[id]['name'])+"\n")


func _on_ChatBt_pressed():
	var chat_txt = chat_edit.text
	
	rpc_id(1,"sendChat", u_name.text, chat_txt)
	

remote func sendChat(name_txt, chat_txt):
	if get_tree().is_network_server():
		for idp in net.players:
			rpc_id(idp,"refreshChatList",name_txt, chat_txt)

remote func refreshChatList(name_txt, chat_txt):
	chat_list.append_bbcode("<"+ name_txt +"> "+ chat_txt +"\n")
	chat_list.scroll_following
	
