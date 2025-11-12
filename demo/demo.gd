extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bot_instance=StarBot.new()
	add_child(bot_instance)
	bot_instance.initialize({})
	pass # Replace with function body.
