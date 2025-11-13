extends StarBotChatNode
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	input_port_array=["Bool","String"]
	output_port_array=[]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is bool  and input_port_data[0] and input_port_data[1] is String:
		ModLoader.get_autoload("iirose/iirose").sent_tu(input_port_data[1],"")
		return true
	else:
		return false
