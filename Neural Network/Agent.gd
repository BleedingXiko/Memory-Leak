extends KinematicBody2D

var motion = Vector2()
const GRAVITY = 20

var fnc = Activation_func.new("relu", "sigmoid")
var brain = NeuralNetwork.new(4, [5], 1, fnc)

var score = 0.0
var fitness = 0.0


signal got_hit

# use the neural network to predict the next move
func think(parameter):
	var inputs = []
	inputs.append()
	inputs.append()
	inputs.append()
	inputs.append()
	
	var outputs = brain.predict(inputs)
	if outputs[0] > 0.5:
		action()

# apply motion if needed
func move(delta):
	score += 1
	motion.y += GRAVITY
	var col = move_and_collide(motion * delta)
	
	if col:
		emit_signal("got_hit", self)
		queue_free()

func action():
	pass
	#action goes here

func mutate():
	brain.mutate()


func save_brain():
	neural_data[0].input_nodes = brain.input_nodes
	neural_data[0].hidden_nodes = brain.hidden_nodes
	neural_data[0].output_nodes = brain.output_nodes
	
	neural_data[0].weights_ih = brain.weights_ih.to_array()
	neural_data[0].weights_ho = brain.weights_ho.to_array()
	
	neural_data[0].bias_h = brain.bias_h.to_array()
	neural_data[0].bias_o = brain.bias_o.to_array()
	var file = File.new()
	file.open(neural_path, File.WRITE)
	file.store_var(neural_data[0])
	file.close()


func load_brain():
	
	var file = File.new()
	
	if file.file_exists(neural_path):
		file.open(neural_path, file.READ)
		var net = file.get_var()
		brain = NeuralNetwork.new(net)
		file.close()
