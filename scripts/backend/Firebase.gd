extends Node 

# ! This class is autoloaded, meaning that it runs whichever scene
# ! we are in the game. This is made so that we could access all
# ! these functions anytime. -krColonia

const API_KEY := "AIzaSyAWJri4kTZFR2SRanw-HYVCvytTSqcL9Ko"
const PROJECT_ID := "code-quest-game"
# ? ^ this probably SHOULD NOT be public for privacy reasons.
# ?   IF PUSHING TO PUBLIC GITHUB REPO, HIDE THESE! -krColonia

# ? URLs for HTTPRequests
const REGISTER_URL := "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=%s" % API_KEY
const LOGIN_URL := "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=%s" % API_KEY
const DB_URL := "https://code-quest-game-default-rtdb.firebaseio.com/"

# ? Variable for storing user information like ID and Token
var auth_fin = false
var user_info = {}

# ? Get functions used when retrieving information from this class to other classes

func _get_token_id_from_result(result: PackedByteArray) -> String:
	for i in result:
		print(i)
	var result_body = JSON.parse_string(result.get_string_from_utf8())
	return result_body.idToken

func _get_user_info(result: PackedByteArray) -> Dictionary:
	var result_body = JSON.parse_string(result.get_string_from_utf8())
	return {
		"token": result_body.idToken,
		"refreshToken": result_body.refreshToken,
		"id": result_body.localId
	}

func _get_request_headers() -> PackedStringArray:
	return PackedStringArray([
		"Content-Type: application/json",
		"Authorization: Bearer %s" % user_info.token
	])

# ? Firebase Authentication REST API call functions

func register(email: String, password: String, http: HTTPRequest) -> void:
	if !http.is_connected("request_completed", _on_auth_request_completed):
		http.request_completed.connect(_on_auth_request_completed)
	var body := {
		"email" : email,
		"password" : password
	}
	http.request(REGISTER_URL, [], HTTPClient.METHOD_POST, JSON.stringify(body))
		
func login(email: String, password: String, http: HTTPRequest) -> void:
	if !http.is_connected("request_completed", _on_auth_request_completed):
		http.request_completed.connect(_on_auth_request_completed)
	var body := {
		"email" : email,
		"password" : password,
		"returnSecureToken" : true
	}
	http.request(LOGIN_URL, [], HTTPClient.METHOD_POST, JSON.stringify(body))

func _on_auth_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray):
	var json = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		user_info = _get_user_info(body)
		auth_fin = true
	else:
		print("Response Code: " + str(response_code))
		print(json.error.message.capitalize())

# ? Firebase Realtime Database REST API call Functions
# ! FIX FIREBASE REALTIME DATABASE SECURITY SETTINGS AFTER TESTS AND DEBUGGING

func save_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	if !http.is_connected("request_completed", _on_db_request_completed):
		http.request_completed.connect(_on_db_request_completed)
	var url : String = DB_URL + path + "?auth=%s" % user_info.token
	http.request(url, _get_request_headers(), HTTPClient.METHOD_PUT, str(fields))

func get_document(path: String, http: HTTPRequest) -> void:
	if !http.is_connected("request_completed", _on_db_request_completed):
		http.request_completed.connect(_on_db_request_completed)
	var url : String = DB_URL + path + "?auth=%s" % user_info.token
	http.request(url, _get_request_headers(), HTTPClient.METHOD_GET)

func update_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	if !http.is_connected("request_completed", _on_db_request_completed):
		http.request_completed.connect(_on_db_request_completed)
	var url : String = DB_URL + path + "?auth=%s" % user_info.token
	http.request(url, _get_request_headers(), HTTPClient.METHOD_PATCH, str(fields))

func delete_document(path: String, http:HTTPRequest) -> void:
	if !http.is_connected("request_completed", _on_db_request_completed):
		http.request_completed.connect(_on_db_request_completed)
	var url : String = DB_URL + path + "?auth=%s" % user_info.token
	http.request(url, _get_request_headers(), HTTPClient.METHOD_DELETE)

func _on_db_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray):
	print(response_code)
