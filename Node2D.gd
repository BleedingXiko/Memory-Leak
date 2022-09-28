extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var net = NeuralNetwork.new(3, [6], 1, "relu", "sigmoid")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Visualization.visualize(net)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print_stray_nodes()
	$Label.text = "Memory" + str(OS.get_static_memory_usage())
	#OS.print_all_resources("res://test.txt")



func _on_TouchScreenButton_pressed():
	get_tree().reload_current_scene()
