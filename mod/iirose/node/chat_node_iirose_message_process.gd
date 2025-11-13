extends StarBotChatNode
##蔷薇消息处理节点
var get_key:String=""
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	type=6
	input_port_array=["Dictionary"]
	variable_name_array=["get_key"]
	variable_type_array=[StarBotChatNode.variable_type.TYPE_SELECT]
	variable_type_more=[[["name","uid","message"],["发信人名字","发信人UID","发信人信息内容"]]]
	get_key="name"
	variable_name_view=["输出"]
	output_port_array=["Bool","String"]
func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	#print(variable_name)
	if input_port_data[0] is Dictionary:
		if input_port_data[0].has(get_key):
			output_port_data[0]=true
			output_port_data[1]=input_port_data[0][get_key]
			
		else:
			output_port_data[0]=false
			output_port_data[1]=""
		return true
	else:
		return false
	pass


func load_from_data(data:Dictionary):
	super.load_from_data(data)
	if data.has("get_key"):
		var new_mes=data["get_key"]
		get_key=new_mes
		#print(new_mes)
func export_data(data:Dictionary):
	super.export_data(data)
	#print("当前字典键",variable_name)
	data["get_key"]=get_key
