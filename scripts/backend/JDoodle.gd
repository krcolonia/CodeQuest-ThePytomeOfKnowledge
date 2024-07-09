extends Node

const CLIENT_ID := "4f548172c9731412d6eaecb65ad4939e"
const CLIENT_SECRET := "4ac1d0ca01ac519816fd26090a8993035fdb4089791ec8d4f35c69dfdcc19a0f"

const AUTH_URL := "https://api.jdoodle.com/v1/auth-token"
const EXEC_URL := "https://api.jdoodle.com/v1/execute"

const AUTH_HEADERS := ["Content-Type: application/json"]

func get_auth_token(http: HTTPRequest):
	var auth_data = {
		'clientId' : CLIENT_ID,
		'clientSecret' : CLIENT_SECRET
	}
	http.request(AUTH_URL, AUTH_HEADERS, HTTPClient.METHOD_POST, JSON.stringify(auth_data))