#----------------------
#版权所有：
#	李志鹏
#	新疆大学 计算机科学与技术学院 
#	计算机科学与技术 21-3班
#	毕业设计
#	学号：20211401239
#----------------------



extends StarBotChatSingleton

class_name StarBotGlobalConfig

##当配置改变时发出
signal config_chages(section,item,value)


var config_file_path:String:
	get():
		if environment==null:
			return "res://config.cfg"
		#if OS.is_debug_build():
			#return "res://config.cfg"
		#else:
			#return OS.get_executable_path().get_base_dir()+"/config.cfg"
		return environment.get_arg("config_path","res://config.cfg")

var _config_cache:ConfigFile

var config_file:ConfigFile:
	
	get():
		if _config_cache!=null:
			return _config_cache
			
		else:
			if not FileAccess.file_exists(config_file_path):
				var config=ConfigFile.new()
				_config_cache=config
				var err=config.save(config_file_path)
				if err!=OK:
					push_error("创建配置文件失败")
				return config
			var config=ConfigFile.new()
			config.load(config_file_path)
			_config_cache=config
			return config


func get_item_value(section:String,item:String):
	if section_db.has(section):
		var section_instance:StarBotConfigSection=section_db[section]
		if section_instance.has_item(item):
			var item_instance:StarBotConfigItem=section_instance.get_item(item)
			var value=config_file.get_value(section,item,item_instance.item_type.default_value)
			return value
	push_error("不存在的配置条目")
	return null
func set_item_value(section:String,item:String,value):
	if section_db.has(section):
		var section_instance:StarBotConfigSection=section_db[section]
		if section_instance.has_item(item):
			var item_instance:StarBotConfigItem=section_instance.get_item(item)
			if item_instance.item_type.is_legal(value):
				config_file.set_value(section,item,value)
				config_file.save(config_file_path)
				pass
			return
			pass
	push_error("不存在的配置条目")
	return null



var section_db:Dictionary[String,StarBotConfigSection]={}
func add_section(section:StarBotConfigSection):
	section_db[section.section_name]=section
func get_section(section_name:String):
	if section_db.has(section_name):
		return section_db[section_name]
	return null	

##获取全部设置节
func get_all_section()->Array:
	return section_db.values()
	
	pass
