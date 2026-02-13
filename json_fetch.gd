extends Node

@export var http_request: HTTPRequest

func _ready():
	http_request.request_completed.connect(_on_request_completed)
	http_request.request("https://yo2ba.github.io/JetSet/changelogs.json")

func _on_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		display(json)
	if response_code == 0:
		print("No connection")
	if response_code == 404:
		print("No data")

func display(data):
	for update in data["versions"]:
		print("Version ", update["version"])
		for change in update["changes"]:
			print("- ", change)
		print("")
