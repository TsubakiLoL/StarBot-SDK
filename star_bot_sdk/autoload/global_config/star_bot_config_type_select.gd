class_name StarBotConfigTypeSelect extends StarBotConfigType

func _init() -> void:
	type=ConfigValueType.SELECT
var select_db:Dictionary[String,String]={}
	
func add_select(select_value:String,select_name:String):
	select_db[select_value]=select_name
func set_default(select_value:String):
	if  select_db.has(select_value):
		default_value=select_value
	else:
		push_error("设置的默认值不存在")
func get_all_value()->Array[String]:
	
	return select_db.keys()
func get_value_name(value:String)->String:
	
	return select_db[value]
		
	pass
func is_legal(value)->bool:
	return value is String and select_db.has(value)
