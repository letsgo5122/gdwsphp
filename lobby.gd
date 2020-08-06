extends Node

func _ready():
	pass # Replace with function body.
func _on_Create_pressed():
	var u_name = $CreateAccount/AccountPanel/UserNameEdit.text
	var u_password = $CreateAccount/AccountPanel/passwordEdit.text
	var trimname = u_name.strip_edges(true,true)
	if trimname != "":
		var SERVER_PHP = "http://localhost"
		var url = SERVER_PHP+"/"+"gdapi.php"
		#post json
		var act = "insert"
		var data_to_send = {"act":act,"name":trimname,"passwd":u_password}
		var query = JSON.print(data_to_send)
		# Add 'Content-Type' header:
		var headers = ["Content-Type: application/json"]
		var error = $HTTPPost.request(url, headers, false, HTTPClient.METHOD_POST, query)
		if error != OK:
			push_error("An error occurred in the HTTP request.")
	else:
		$CreateAccount/AccountPanel/AccountList.text = "Please Enter User Name And Nick Name."

func _on_HTTPPost_request_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200 :
			#print(body.get_string_from_utf8())
			var json = JSON.parse(body.get_string_from_utf8())
			print(json.result)
			if !json.result.empty():
				for ar in json.result:
					$CreateAccount/AccountPanel/AccountList.text = ""
					$CreateAccount/AccountPanel/AccountList.append_bbcode("ID:"+str(ar.get('id'))+"  Name:"+ar.get('name')+" Create Success!")
			else:
				$CreateAccount/AccountPanel/AccountList.text = "Username Already Exist."
		else:
			$CreateAccount/AccountPanel/AccountList.text = "err code:"+str(response_code)
