class_name StarBotConfigTypeText extends StarBotConfigType


var is_secret:bool
func _init(default_value:String,is_secret:bool=false) -> void:
	self.default_value=default_value
	self.is_secret=is_secret
	type=ConfigValueType.TEXT
func is_legal(value)->bool:
		
		
	return value is String
