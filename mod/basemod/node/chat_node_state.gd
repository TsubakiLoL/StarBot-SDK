extends StarBotChatNode



var is_init:bool=false:
	set(val):
		if not is_init and val:
			#print("设置状态：",val)
			root.set_init_state(self)
		is_init=val
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	type=0
	variable_name_array=["is_init"]
	variable_type_array=[StarBotChatNode.variable_type.TYPE_BOOL]
	variable_type_more=[]
	variable_name_view=["进入状态"]
	input_port_array=["ChangeState"]
	input_port_name=["转换"]
	output_port_array=["StateWithTriger"]
	output_port_name=["触发"]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is bool and input_port_data[0]:
		if root!=null:
			root.change_state(id,self)
	return false
	


func load_from_data(data:Dictionary):
	super.load_from_data(data)
	if data.has("is_init"):
		var is_init_state=data["is_init"]
		if is_init_state is bool:
			is_init=is_init_state
func export_data(data:Dictionary):
	super.export_data(data)
	data["is_init"]=is_init
