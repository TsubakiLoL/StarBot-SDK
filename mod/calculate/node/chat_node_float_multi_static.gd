extends StarBotChatNode
var mes:String=""
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	variable_name_array=["mes"]
	variable_type_array=[StarBotChatNode.variable_type.TYPE_STRING]
	variable_type_more=[]
	variable_name_view=["输出(请填写有效数字，否则会输出原数字)"]
	input_port_array=["Float"]
	output_port_array=["Float"]
	
	input_port_name=["被乘数"]
	output_port_name=["积"]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is float and mes.is_valid_float():
		output_port_data[0]=input_port_data[0]*mes.to_float()
		return true
	elif input_port_data[0] is float:
		output_port_data[0]=input_port_data[0]
		return true
	else:
		return false
	
	
	
	
	
	
func load_from_data(data:Dictionary):
	super.load_from_data(data)
	if data.has("mes"):
		var new_mes=data["mes"]
		mes=new_mes
func export_data(data:Dictionary):
	super.export_data(data)
	data["mes"]=mes
