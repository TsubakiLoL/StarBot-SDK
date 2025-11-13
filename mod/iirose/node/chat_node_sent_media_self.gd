extends StarBotChatNode

var music_type:String="=0"
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	
	
	
	variable_name_array=["music_type"]
	variable_type_array=[StarBotChatNode.variable_type.TYPE_SELECT]
	variable_type_more=[
		[
			["=0","=1"],
			["自定义音频",
			"自定义视频",
			]
		]
	]
	input_port_name=["是否操作","地址（url）","媒体时长","封面","名字","作者"]
	music_type="=0"
	
	input_port_array=["Bool","String","Float","String","String","String"]
	output_port_array=[]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is bool and input_port_data[1] is String and input_port_data[2] is float and input_port_data[3] is String and input_port_data[4] is String and input_port_data[5] is String:
		if input_port_data[0]:
			ModLoader.get_autoload("iirose/iirose").sent_media_self(input_port_data[1],input_port_data[2],input_port_data[3],input_port_data[4],input_port_data[5],music_type)
		return true
	else:
		return false


#sent_media_self(addr:String,long:float,cover:String,media_name:String,author:String,type:String):