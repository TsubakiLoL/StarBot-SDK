extends StarBotChatNode
var mes:String=""
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	variable_name_array=["mes"]
	variable_type_array=[StarBotChatNode.variable_type.TYPE_STRING]
	variable_type_more=[]
	variable_name_view=["输出(请填写有效数字，否则会输出0)"]
	input_port_array=["Dictionary"]
	output_port_array=["Float"]
	
	input_port_name=["触发"]
	output_port_name=["输出"]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	var data:float=0
	if mes.is_valid_float():
		data=mes.to_float()
	
	output_port_data[0]=mes
	return true
	


func load_from_data(data:Dictionary):
	super.load_from_data(data)
	if data.has("mes"):
		var new_mes=data["mes"]
		mes=new_mes
func export_data(data:Dictionary):
	super.export_data(data)
	data["mes"]=mes
