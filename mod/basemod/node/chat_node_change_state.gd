extends StarBotChatNode
##状态转换器节点，输入为Bool类型，输出为ChangeState类型，当Bool为真时，通知下方state执行转换
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	input_port_array=["Bool"]
	input_port_name=["是否转换"]
	output_port_array=["ChangeState"]
	output_port_name=["转换信号"]
func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is bool:
		output_port_data[0]=input_port_data[0]
		return true
	else:
		return false
	pass
