extends StarBotChatNode
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	input_port_array=["String","String","String"]
	output_port_array=["String"]
	input_port_name=["输入1","输入2","输入3"]
	output_port_name=["连接"]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is String and input_port_data[1] is String and input_port_data[2] is String :
		output_port_data[0]=input_port_data[0]+input_port_data[1]+input_port_data[2]
		return true
	else:
		return false
