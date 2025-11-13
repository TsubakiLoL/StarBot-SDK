extends StarBotChatNode
enum compare_type{
	TYPE_MORE=0,
	TYPE_SAME=1,
	TYPE_LESS=2,
	TYPE_MORE_OR_SAME=3,
	TYPE_LESS_OR_SAME=4
}
var c_type:compare_type=compare_type.TYPE_MORE
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	variable_name_array=["c_type"]
	variable_type_array=[StarBotChatNode.variable_type.TYPE_SELECT]
	variable_type_more=[[[0,1,2,3,4],[">","=","<",">=","<="]]]
	variable_name_view=["比较模式"]
	input_port_array=["Float","Float"]
	output_port_array=["Bool"]
	
	input_port_name=["参数1","参数2"]
	output_port_name=["结果"]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is float and input_port_data[1] is float:
		var res:bool=false
		match c_type:
			compare_type.TYPE_MORE:
				res=input_port_data[0]>input_port_data[1]
			compare_type.TYPE_SAME:
				res=input_port_data[0]==input_port_data[1]
			compare_type.TYPE_LESS:
				res=input_port_data[0]<input_port_data[1]
			compare_type.TYPE_MORE_OR_SAME:
				res=input_port_data[0]>=input_port_data[1]
			compare_type.TYPE_LESS_OR_SAME:
				res=input_port_data[0]<=input_port_data[1]
		
		output_port_data[0]=res
		return true
	else:
		return false
	
	
	
	
	
func load_from_data(data:Dictionary):
	super.load_from_data(data)
	if data.has("c_type"):
		print("加载比较器类型")
		var new_c_type=data["c_type"]
		if int(new_c_type) in compare_type.values():
			c_type=int(new_c_type)
			print("加载成功")
func export_data(data:Dictionary):
	super.export_data(data)
	data["c_type"]=c_type
