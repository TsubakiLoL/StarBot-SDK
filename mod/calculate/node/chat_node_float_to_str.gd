extends StarBotChatNode

var is_int:bool=false

func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	variable_name_array=["is_int"]
	variable_type_array=[StarBotChatNode.variable_type.TYPE_BOOL]
	variable_type_more=[]
	variable_name_view=["取整"]
	input_port_array=["Float"]
	output_port_array=["String"]
	
	input_port_name=["输入"]
	output_port_name=["输出"]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	var data=input_port_data[0]
	var res:String=""
	if is_int:
		res=str(int(data))
	else:
		res=str(data)
	output_port_data[0]=res
	return true


func load_from_data(data:Dictionary):
	super.load_from_data(data)
	if data.has("is_int"):
		var new_mes=data["is_int"]
		is_int=new_mes
func export_data(data:Dictionary):
	super.export_data(data)
	data["is_int"]=is_int