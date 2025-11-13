extends StarBotChatNode
var mes:String=""
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	type=5
	variable_name_array=["mes"]
	variable_type_array=[StarBotChatNode.variable_type.TYPE_STRING]
	variable_type_more=[]
	variable_name_view=["信息"]
	input_port_array=["Bool"]
	output_port_array=[]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is bool and input_port_data[0]:
		ModLoader.get_autoload("iirose/iirose").sent_room_message(mes)
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


