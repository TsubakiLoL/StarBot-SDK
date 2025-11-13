extends StarBotChatNode


func _init(root:StarBotChatNodeRoot) -> void:
	#父类初始化
	super._init(root)
	#输入节点类型数组
	input_port_array=["Float"]
	#输出节点类型数组
	output_port_array=["Float","Float","Float"]


#当全部输入就绪时调用
#处理输入，输入的为状态机的标识ID，大部分情况为用户ID
func process_input(id:String,input_port_data:Array,output_port_data:Array):
	#将true发送到第0个输出端口，并传入ID
	if input_port_data[0] is float:
		var int_unix:int=int(input_port_data[0])
		var hour:int=int_unix/3600
		int_unix=int_unix%3600
		var minute:int=int_unix/60
		int_unix=int_unix%60
		output_port_data[0]=float(hour)
		output_port_data[1]=float(minute)
		output_port_data[2]=float(int_unix)
		return true
	return false
