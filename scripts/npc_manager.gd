extends Node

#@onready var FNPC = $"../FellowNPC"
@onready var taskManager = $"../TaskManager"
@onready var itemManager = $"../ItemManager"
@onready var NPCs = $"../NPCs"
var cooldown = 5.0

var taskQueue = {}

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func RequestTask(NPC):
	if taskQueue.has(NPC.name):
		print('ici')
		if taskQueue[NPC.name] == null :
			AddCustomTask(NPC)
			return taskQueue[NPC.name]
		else :
			taskQueue[NPC.name] = null
			return null
		
	
		
func BeginWork():
	for NPC in NPCs.get_children():
		if NPC.scene_file_path == "res://scenes/fellownpc.tscn":
			AddCustomTask(NPC)
		


func AddCustomTask(NPC):
	var nodes = null
	var newTask = Task.new()
	for preset in Global.presetsWork.keys():
		nodes = Global.presetsWork[preset]
		newTask.CreateCustomTask(nodes)
		if !taskQueue.has(NPC.name):
			taskQueue[NPC.name] = null
		taskQueue[NPC.name] = newTask
		

func _on_start_button_pressed() -> void:
	BeginWork()
