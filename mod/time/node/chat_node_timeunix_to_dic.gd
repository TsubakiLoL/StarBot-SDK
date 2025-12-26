extends StarBotChatNode


func _init(root:StarBotChatNodeRoot) -> void:
	#父类初始化
	super._init(root)
	#输入节点类型数组
	input_port_array=["Float"]
	
	input_port_name=["时间戳"]
	#输出节点类型数组
	
	
	output_port_name=["年","月","日","周"]
	output_port_array=["Float","Float","Float","Float"]


#当全部输入就绪时调用
#处理输入，输入的为状态机的标识ID，大部分情况为用户ID
func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	#将true发送到第0个输出端口，并传入ID
	if input_port_data[0] is float:
		var dic:Dictionary=Time.get_date_dict_from_unix_time(int(input_port_data[0]))
		output_port_data[0]=dic["year"]
		output_port_data[1]=dic["month"]
		output_port_data[2]=dic["day"]
		output_port_data[3]=dic["weekday"]
		return true
	return false

	

