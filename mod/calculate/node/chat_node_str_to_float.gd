extends StarBotChatNode

func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	input_port_array=["String"]
	output_port_array=["Float"]
	input_port_name=["数字字符串"]
	output_port_name=["数字"]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is String and input_port_data[0].is_valid_float():
		output_port_data[0]=input_port_data[0].to_float()
	else:
		output_port_data[0]=0
	return true
