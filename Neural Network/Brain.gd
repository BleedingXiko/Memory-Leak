class_name NeuralNetwork

var input_nodes := 0
var hidden_nodes := [0]
var output_nodes := 0

var layer = []

var neural_data = {
	"input_nodes": 0,
	"hidden_nodes": [],
	"output_nodes": 0,
		
	"layer": [],
	}
var neural_path = "res://neural.data"

var learning_rate = .8
var mutation_rate = 0.1

var mutation_func_ref: FuncRef

var activation_function
var output_activation_function
#var d_activation_function

# CONSTRUCTORS
func _init(a, b = 1, c = 1, fnc = "relu", ofnc = "sigmoid"):
	randomize()
	mutation_func_ref = funcref(self, "mutation_func")
	
	
	activation_function = fnc
	output_activation_function = ofnc
	#d_activation_function = fnc._dfunc
	
	if a is Dictionary:
		construct_from_var(a)
	
	elif a is int:
		construct_from_sizes(a, b, c)
	else:
		construct_from_nn(a)


func add_layer(ih = false,af = activation_function,input_nodes = null, nodes = 3):
	
	layer.append(NeuralNetworkLayer.new(ih,self,af, input_nodes, nodes))

func construct_from_sizes(a, b, c):
	input_nodes = a
	
	if b is int:
		hidden_nodes = [b]
	else:
		hidden_nodes = b
	output_nodes = c
	
	add_layer(false,activation_function, input_nodes, hidden_nodes[0])
	
	var i = 1
	
	while i < hidden_nodes.size():
		add_layer(false,activation_function, hidden_nodes[i - 1], hidden_nodes[i])
		
		i += 1
	add_layer(false,output_activation_function, hidden_nodes[hidden_nodes.size() - 1], output_nodes)


func construct_from_var(a):
	input_nodes = a.input_nodes
	hidden_nodes = a.hidden_nodes
	output_nodes = a.output_nodes
	
	for i in a.layer.size():
		add_layer(true,a.layer[i].af, a.layer[i].weights, a.layer[i].bias)

func construct_from_nn(a):
	input_nodes = a.input_nodes
	
	hidden_nodes = a.hidden_nodes
	output_nodes = a.output_nodes
	
	for i in a.layer.size():
		add_layer(true,a.layer[i].activation_func, a.layer[i].weights, a.layer[i].bias)


func testAll(test):
	var correct = 0
	for i in test.size() - 1:
		var data = test[i]
		var inputs = data.inputs
		var target = data.targets
		
		var guess = predict(inputs)
		if round(guess[0]) == target[0]:
			correct += 1
		
	var percent = 100 * correct / test.size()
	#print("Accuracy: " + str(percent) + "%")
	return percent
func predict(input_array: Array) -> Array:
	#print(layer.size())
	var inputs = Matrix.new(input_array)
	
	var outputs = inputs
	
	var _i = 0
	
	while _i < layer.size():
		outputs = layer[_i].predict(outputs)
		_i += 1
	
	return outputs.to_array()



func train(input_array, target_array):
	var inputs = Matrix.new(input_array)
	var targets = Matrix.new(target_array)
	
	var predictions = []
	var prediction = inputs
	
	
	var _i = 0
	
	while _i < layer.size():
		prediction = layer[_i].predict(prediction)
		predictions.append(prediction)
		_i += 1
	
	
	var outputs = predictions[predictions.size() - 1]
	
	var curr_err = MatrixOperator.subtract(targets, outputs)
	
	var i = layer.size() - 1
	
	while i >= 0:
		if i == 0:
			curr_err = layer[i].applyError(predictions[i], inputs, curr_err)
		else:
			curr_err = layer[i].applyError(predictions[i], predictions[i - 1], curr_err)
		i -= 1


func _save():
	neural_data.input_nodes = input_nodes
	neural_data.hidden_nodes = hidden_nodes
	neural_data.output_nodes = output_nodes
	
	for i in layer.size():
		var data = {"weights": layer[i].weights.to_array(true),
					"bias": layer[i].bias.to_array(true),
					"af": layer[i].fn._func.function}
		neural_data.layer.append(data)
	
	var file = File.new()
	file.open(neural_path, File.WRITE)
	file.store_var(neural_data)
	file.close()
	print("saved" + str(neural_data))

func _load():
	var file = File.new()
	if file.file_exists(neural_path):
		file.open(neural_path, File.READ)
		var a = file.get_var()
		file.close()
		_init(a)
		print("loaded" + str(a))

func mutate():
	for i in layer.size():
		layer[i].weights.map(mutation_func_ref)
		layer[i].bias.map(mutation_func_ref)

func duplicate():
	return get_script().new(self)

func mutation_func(val):
	if randf() < mutation_rate:
		return val + rand_range(-0.1, 0.1)
	else:
		return val
