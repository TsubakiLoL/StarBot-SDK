class_name StarBotConfigItem

var item_view:String=""
var item_name:String=""
var item_type:StarBotConfigType
func _init(view:String,name:String,type:StarBotConfigType) -> void:
	self.item_view=view
	self.item_name=name
	self.item_type=type
	pass
