extends StarBotChatNode
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	input_port_array=["Dictionary"]
	output_port_array=["Float"]
	input_port_name=["触发"]
	output_port_name=["随机数（0-1）"]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	output_port_data[0]=randf()
	return true
