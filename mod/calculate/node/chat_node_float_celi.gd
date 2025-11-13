extends StarBotChatNode
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	input_port_array=["Float"]
	output_port_array=["Float"]
	input_port_name=["输入"]
	output_port_name=["结果"]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is float:
		if input_port_data[0]>0:
			output_port_data[0]=float(int(input_port_data[0])+1)
		elif input_port_data[0]==0:
			output_port_data[0]=0
		else:
			output_port_data[0]=float(int(input_port_data[0]))
		return true
	else:
		return false
	
	
