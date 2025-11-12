class_name StarBotConfigTypeBool extends StarBotConfigType

func _init(default_value:bool) -> void:
	type=ConfigValueType.BOOL
	self.default_value=default_value
func is_legal(value)->bool:
		return value is bool
