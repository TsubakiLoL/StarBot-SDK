extends StarBotChatNode
##正则匹配节点
var regex_string:String="":
	set(val):
		regex=RegEx.create_from_string(val)
		regex_string=val
var regex=RegEx.new()
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	variable_name_array=["regex_string"]
	variable_type_array=[StarBotChatNode.variable_type.TYPE_STRING]
	variable_name_view=["正则表达式"]
	input_port_array=["String"]
	output_port_array=["Bool","Dictionary"]
	input_port_name=["输入"]
	output_port_name=["是否匹配","匹配结果"]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is String and regex.is_valid():
		var res=regex.search(input_port_data[0])
		if res==null:
			output_port_data[0]=false
			output_port_data[1]={}
		else:
			var exe_res:Dictionary={}
			for i in res.names.keys():
				exe_res[i]=res.strings[res.names[i]]
			if res.names.size()!=0:
				output_port_data[0]=true
				output_port_data[1]=exe_res
			else:
				output_port_data[0]=false
				output_port_data[1]={}
		return true
	else:
		return false

func load_from_data(data:Dictionary):
	super.load_from_data(data)
	if data.has("regex_string"):
		var new_mes=data["regex_string"]
		regex_string=new_mes
func export_data(data:Dictionary):
	super.export_data(data)
	data["regex_string"]=regex_string
