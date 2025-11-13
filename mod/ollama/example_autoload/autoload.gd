extends Node
func create_request(model:String,API:String,content:String):
	print("创建ollama请求")
	var new_http=OllamaRequest.new()
	new_http.time_out=30
	new_http.model=model
	new_http.API=API
	add_child(new_http)
	new_http.ollama_chat_request(content)
	return new_http
class OllamaRequest extends HTTPRequest:
	var model="llama2"
	var API:String="http://localhost:11434/api/generate"
	var is_success:bool=false
	var response:String=""
	signal request_complete
	func _ready() -> void:
		request_completed.connect(_on_request_completed)
	func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
		var res=body.get_string_from_utf8()
		var dic=JSON.parse_string(res)
		if dic is Dictionary:
			if dic.has("done") and dic["done"] is bool and dic["done"] and dic.has("response") and dic["response"] is String:
				is_success=true
				response=dic["response"]
			else:
				is_success=false
		request_complete.emit()
	func ollama_chat_request(str:String):
		var dic={
  		"model": model,
 		"prompt": "Why is the sky blue?",
  		"stream": false
		}
		dic["prompt"]=str
		request(API,PackedStringArray(),HTTPClient.METHOD_POST,JSON.stringify(dic))
