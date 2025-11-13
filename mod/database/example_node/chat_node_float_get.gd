extends StarBotChatNode

#节点初始化
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	variable_name_array=[]
	variable_type_array=[]
	variable_type_more=[]
	variable_name_view=[]
	input_port_array=["Dictionary","String"]
	output_port_array=["Bool","Float"]


#当全部输入就绪时调用
#处理输入，输入的为状态机的标识ID，大部分情况为用户ID
func process_input(id:String,input_port_data:Array,output_port_data:Array):
	#第0个端口的输入数据，获取方式以此类推
	input_port_data[0]
	if input_port_data[1] is String:
		#将true发送到第0个输出端口，并传入ID
		var data=get_autoload().get_data(input_port_data[1])
		if data is float:
			output_port_data[0]=true
			output_port_data[1]=data
		else:
			output_port_data[0]=false
			output_port_data[1]=0.0
		return true
	return false

	

func get_autoload():
	return ModLoader.get_autoload("database/database")