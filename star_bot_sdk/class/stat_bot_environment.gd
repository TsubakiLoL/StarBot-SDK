class_name StarBotEnvironment

##环境参数
var environment_args:Dictionary[String,String]={}


##单例数据
var singleton_data:Dictionary[String,WeakRef]={}

##注册单例
func generate_singleton(parent:StarBot,singleton_name:String,scene:PackedScene):
	var new_instance:StarBotChatSingleton=scene.instantiate()
	new_instance.singleton_name=singleton_name
	new_instance.environment=self
	singleton_data[singleton_name]=weakref(new_instance)
	parent.add_child_injection(new_instance)
##使用脚本的方式注册单例（必须是StarBotChatSingleton，且构造函数参数为空）
func generate_script_singleton(parent:StarBot,singleton_name:String,script:GDScript):
	var new_instance:StarBotChatSingleton=script.new()
	new_instance.singleton_name=singleton_name
	new_instance.environment=self
	singleton_data[singleton_name]=weakref(new_instance)
	parent.add_child_injection(new_instance)


##使用现有实例添加单例
func add_singleton(singleton_name:String,node:StarBotChatSingleton):
	node.singleton_name=singleton_name
	singleton_data[singleton_name]=weakref(node)


##获取单例
func get_singletion(singleton_name:String)->StarBotChatSingleton:
	if not singleton_data.has(singleton_name):
		return null
	var weak_ref:WeakRef=singleton_data[singleton_name]
	return weak_ref.get_ref()

##获取环境参数
func get_arg(arg_name:String,default_value:String=""):
	if environment_args.has(arg_name):
		
		return environment_args[arg_name]
	else:
		return default_value
