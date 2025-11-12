class_name StarBotConfigSection
var section_view:String=""
	
var section_name:String=""
	
var item_db:Dictionary[String,StarBotConfigItem]={}

func _init(view:String,name:String) -> void:
	self.section_view=view
	self.section_name=name
	pass
	
func add_item(item:StarBotConfigItem):
	item_db[item.item_name]=item
func has_item(item_name:String):
	
	return item_db.has(item_name)
func get_item(item_name:String):
	if item_db.has(item_name):
		return item_db[item_name]
	return null
