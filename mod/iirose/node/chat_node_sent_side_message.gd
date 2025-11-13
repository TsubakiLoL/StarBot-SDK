extends StarBotChatNode
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	type=4
	input_port_array=["String"]
	output_port_array=[]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is String:
		ModLoader.get_autoload("iirose/iirose").sent_side_message(input_port_data[0])
		return true
	else:
		return false
