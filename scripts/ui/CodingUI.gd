extends CanvasLayer

@onready var code: CodeEdit = $Panel/MarginContainer/VBoxContainer/CodeEdit
@onready var console: TextEdit = $Panel/MarginContainer/VBoxContainer/Output
@onready var http: HTTPRequest = $HTTPRequest

const CLIENT_ID # ? REMOVED CLIENT ID, If you're planning on using the Client ID of my account, tough luck.
const CLIENT_SECRET # ? REMOVED CLIENT SECRET, If you're planning on using the Client Secret of my account, tough luck.

const EXEC_URL := "https://api.jdoodle.com/v1/execute"

const AUTH_HEADERS := ["Content-Type: application/json"]

func _on_run_btn_pressed():
	pass_code_to_api(code.text)

func pass_code_to_api(script: String):
	var auth_data = {
		'clientId' : CLIENT_ID,
		'clientSecret' : CLIENT_SECRET,
		'script' : script,
		"language" : "python3",
		"versionIndex": 5
	}
	http.request(EXEC_URL, AUTH_HEADERS, HTTPClient.METHOD_POST, JSON.stringify(auth_data))

func _on_http_request_request_completed(_result:int, response_code:int, _headers:PackedStringArray, body:PackedByteArray):
	var data = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		console.text = "Output:\n" + data.output
	else:
		print("error, API did not connect")
