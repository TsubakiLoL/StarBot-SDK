extends StarBotChatNode
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	input_port_array=["Float","Float"]
	output_port_array=["Float"]
	input_port_name=["乘数1","乘数2"]
	output_port_name=["积"]
func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is float and input_port_data[1] is float:
		output_port_data[0]=input_port_data[0]*input_port_data[1]
		return true
	else:
		return false
	
	
	
