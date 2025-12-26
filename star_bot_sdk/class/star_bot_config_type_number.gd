class_name StarBotConfigTypeNumber extends StarBotConfigType

var min:int
var max:int
func _init(min:int,max:int,default_value:int) -> void:
	type=ConfigValueType.NUMBER
	self.max=max
	self.min=min
	self.default_value=default_value
func is_legal(value)->bool:
	if not value is int:
		return false
	if value>=min and value<=max:
		return true
	return false
