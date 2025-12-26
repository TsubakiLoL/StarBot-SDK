extends StarBotChatSingleton
##机器人程序实例类
class_name StarBot



const logo="""
              #%              
             =@@+             
            :@@@#               
           .@@@%                
           #@@@: *#..           
-++++=.  =%@@@- =@@@@@@@@%@@%+      ____    _                    ____            _ 
 .-+***=: .=+-  .+***##%%@%+:      / ___|  | |_    __ _   _ __  | __ )    ___   | |_ 
    :=***+-        .:::            \\___ \\  | __|  / _` | | '__| |  _ \\   / _ \\  | __|
      .-++*+      #@@@+             ___) | | |_  | (_| | | |    | |_) | | (_) | | |_ 
        ==:  .-:. =@@@-            |____/   \\__|  \\__,_| |_|    |____/   \\___/   \\__|   
          :-+++++  %@@@         
       -+*+++=::-: -@@@=        
      +**+=:        #@@@.       
     :*=:            :*@+                
                                             
"""




##自身的脚本路径，用于脚本路径拼接
var script_path:String:
	get():
		return get_script().resource_path.get_base_dir()

##需要在初始化时实例的单例
var singleton_scene:Dictionary[String,GDScript]={
	"GlobalConfig":StarBotGlobalConfig,
	"ModLoader":StarBotModLoader,
	"PromptMessageControler":StarBotPromptMessageControler
}

func _ready() -> void:
	singleton_name="StarBot"


##初始化，初始化后才开始运行
func initialize(args:Dictionary[String,String]):
	print(logo)
	environment=StarBotEnvironment.new()
	environment.environment_args=args
	for i in singleton_scene.keys():
		var scene=singleton_scene[i]
		environment.generate_script_singleton(self,i,scene)
	environment.add_singleton("StarBot",self)
##创建一个新的节点集，并绑定到本全局运行实例
func create_new_root()->StarBotChatNodeRoot:
	return StarBotChatNodeRoot.new(environment)

##从序列化的字符串中反序列化出NodeRoot
func parse_string(str:String)->StarBotChatNodeRoot:
	return StarBotSerializater.parse_string(str,environment)
##将NodeRoot序列化
func stringfy(root:StarBotChatNodeRoot):
	return StarBotSerializater.stringfy_state_root(root)

##重载插件，当path为空字符串时，则按照上一次载入插件的路径进行载入
func reload_mod(path:String=""):
	if not ModLoader is StarBotModLoader :
		e("未找到ModLoader单例，可能还未进行初始化")
		return 
	if path!="":
		environment.environment_args["mod_load_path"]=path
	ModLoader.reload()
