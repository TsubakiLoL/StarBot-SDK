extends StarBotChatNode

var variable_name:String=""
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	type=41
	input_port_array=["Float"]
	output_port_array=["Float"]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is float:
		output_port_data[0]=input_port_data[0]
		return true
	else:
		return false
