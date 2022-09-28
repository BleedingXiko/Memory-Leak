class_name NeuralNetworkLayer

var activation_func
var parent 
var weights: Matrix
var bias: Matrix
var derivative_func
var fn
func _init(ih, _parent, _activation_func, _input_nodes, _nodes):
	if ih != false:
		make_from_layer(_parent, _activation_func, _input_nodes, _nodes)
	else:
		parent = _parent
		fn = Activation_func.new(str(_activation_func))
		weights = Matrix.new(_nodes, _input_nodes)
		bias = Matrix.new(_nodes, 1)
		weights.randomize()
		bias.randomize()

func make_from_layer(_parent, _activation_func, _input_nodes, _nodes):
	parent = _parent
	fn = Activation_func.new(str(_activation_func))
	#activation_func = _activation_func
	#get_derivative(activation_func)
	weights = Matrix.new(_input_nodes)
	bias = Matrix.new(_nodes)	

func predict(input_matrix):
	var prediction = MatrixOperator.multiply(weights, input_matrix)
	prediction.add(bias)
	prediction.map(fn._func)
	
	return prediction
	
func get_derivative(af = activation_func):
	fn = Activation_func.new(str(af))
	derivative_func = fn._dfunc
	#print(str(derivative_func.function))
	
func applyError(pred, prevPred, curr_err):
	var gradients = MatrixOperator.map(pred, fn._dfunc)
	gradients.multiply(curr_err)
	gradients.multiply(parent.learning_rate)
	
	var prevpred_T = MatrixOperator.transpose(prevPred)
	var weight_deltas = MatrixOperator.multiply(gradients, prevpred_T)
	weights.add(weight_deltas)
	bias.add(gradients)
	
	var weight_T = MatrixOperator.transpose(weights)
	curr_err = MatrixOperator.multiply(weight_T, curr_err)
	
	return curr_err

