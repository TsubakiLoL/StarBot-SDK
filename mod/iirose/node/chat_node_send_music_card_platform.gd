extends StarBotChatNode

var music_type:String="@0"
func _init(root:StarBotChatNodeRoot) -> void:
	super._init(root)
	variable_name_array=["music_type"]
	variable_type_array=[StarBotChatNode.variable_type.TYPE_SELECT]
	variable_type_more=[
		[
			["@0","@1","@2","@3","@4","@5","@6","@7","@8"],
			[
			"网易云音乐",
			"虾米音乐",
			"QQ音乐",
			"千千音乐",
			"酷狗音乐",
			"喜马拉雅FM",
			"荔枝FM",
			"ECHO回声",
			"5SING乐队",
			]
		]
	]
	music_type="@0"
	input_port_array=["Bool","String","String","String","String"]
	input_port_name=["是否操作","音乐名","歌手","封面","颜色"]
	output_port_array=[]

func process_input(id:String,input_port_data:Array,output_port_data:Array)->bool:
	if input_port_data[0] is bool and input_port_data[1] is String and input_port_data[2] is String and input_port_data[3] is String and input_port_data[4] is String:
		if input_port_data[0]:
			ModLoader.get_autoload("iirose/iirose").sent_music_card_platform(music_type,input_port_data[1],input_port_data[2],input_port_data[3],input_port_data[4])
			pass
		return true
	else:
		return false


