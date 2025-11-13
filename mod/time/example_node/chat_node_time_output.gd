extends StarBotChatNode


func _init(root:StarBotChatNodeRoot) -> void:
	#父类初始化
	super._init(root)
	#输入节点类型数组
	input_port_array=["Dictionary"]
	#输出节点类型数组
	output_port_array=["Float"]


#当全部输入就绪时调用
#处理输入，输入的为状态机的标识ID，大部分情况为用户ID
func process_input(id:String,input_port_data:Array,output_port_data:Array):
	#将true发送到第0个输出端口，并传入ID
	output_port_data[0]=Time.get_unix_time_from_system()
	return true

	

