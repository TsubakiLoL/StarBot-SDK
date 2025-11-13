extends StarBotChatNode

var test_var:String="default"

#节点初始化
func _init(root:StarBotChatNodeRoot) -> void:
	#父类初始化
	super._init(root)
	#输入节点类型数组
	input_port_array=["Bool","Float"]
	
	input_port_name=["是否操作","选项"]
	#输出节点类型数组
	output_port_array=["Bool"]
	
	output_port_name=["成功"]


#当全部输入就绪时调用
#处理输入，输入的为状态机的标识ID，大部分情况为用户ID
func process_input(id:String,input_port_data:Array,output_port_data:Array):
	if input_port_data[0] is bool and input_port_data[1] is float :
		#将true发送到第0个输出端口，并传入ID
		if input_port_data[0]:
			output_port_data[0]=ModLoader.get_autoload("dialogue/dialogue").select(int(input_port_data[1]))
		else:
			output_port_data[0]=false
		return true
	return false
