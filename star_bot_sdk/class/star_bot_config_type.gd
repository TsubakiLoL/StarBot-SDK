class_name StarBotConfigType


enum ConfigValueType{
	NUMBER,
	TEXT,
	SELECT,
	BOOL
}
var type:ConfigValueType=ConfigValueType.NUMBER
var default_value
#是否合法
func is_legal(value)->bool:
	return false
