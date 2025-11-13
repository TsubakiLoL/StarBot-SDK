extends StarBotChatNode
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	type=16
	
	input_port_array=["Bool","String"]
	output_port_array=[]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is bool and input_port_data[1] is String and input_port_data[0]:
		ModLoader.get_autoload("iirose/iirose").sent_bullet_message(input_port_data[1])
		return true
	else:
		return false
