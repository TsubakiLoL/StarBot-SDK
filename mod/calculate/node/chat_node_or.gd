extends StarBotChatNode
##或门节点，输入为两个Bool类型，输出两个输入的bool类型的或运算结果，为bool
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	input_port_array=["Bool","Bool"]
	output_port_array=["Bool"]
	
	
	input_port_name=["输入1","输入2"]
	output_port_name=["或"]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is bool and input_port_data[1] is bool:
		output_port_data[0]=input_port_data[0] or input_port_data[1]
		return true
	else:
		return false
