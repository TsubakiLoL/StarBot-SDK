extends StarBotChatNode
##非门，输入一个bool，输出为输入的非，为bool类型
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	input_port_array=["Bool"]
	output_port_array=["Bool"]
	
	
	input_port_name=["输入"]
	output_port_name=["非"]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is bool :
		output_port_data[0]=not input_port_data[0]
		return true
	else:
		return false
