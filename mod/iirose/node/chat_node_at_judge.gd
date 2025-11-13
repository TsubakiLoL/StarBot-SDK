extends StarBotChatNode
##蔷薇艾特监测
var regex=RegEx.create_from_string("^[ ]+\\[\\*(?<name>[^\\]^\\*]+)\\*\\][ ]+$")

var is_contain:bool=false:
	set(value):
		is_contain=value
		if value:
			regex=RegEx.create_from_string(" \\[\\*(?<name>[^\\]^\\*]+)\\*\\] ")
		else:
			RegEx.create_from_string("^[ ]+\\[\\*(?<name>[^\\]^\\*]+)\\*\\][ ]+$")

func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	input_port_array=["String"]
	output_port_array=["Bool","String"]
	variable_name_array=["is_contain"]
	variable_type_array=[StarBotChatNode.variable_type.TYPE_BOOL]
	variable_type_more=[]
	variable_name_view=["匹配包含"]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is String and regex.is_valid():
		var res=regex.search(input_port_data[0])
		if res==null:
			output_port_data[0]=false
			output_port_data[1]=""
		else:
			if res.names.keys().has("name"):
				output_port_data[0]=true
				output_port_data[1]=res.strings[res.names["name"]]
			else:
				output_port_data[0]=false
				output_port_data[1]=""
		return true
	else:
		return false

func load_from_data(data:Dictionary):
	super.load_from_data(data)
	if data.has("is_contain"):
		var new_mes=data["is_contain"]
		is_contain=new_mes
func export_data(data:Dictionary):
	super.export_data(data)
	data["is_contain"]=is_contain
	
	

