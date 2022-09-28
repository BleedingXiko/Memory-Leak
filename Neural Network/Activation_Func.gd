class_name Activation_func

var sigmoid_ref: FuncRef
var dsigmoid_ref: FuncRef
var relu_ref: FuncRef
var drelu_ref: FuncRef
var lrelu_ref: FuncRef
var dlrelu_ref: FuncRef
var elu_ref: FuncRef
var delu_ref: FuncRef
var softmax_ref: FuncRef
var linear_ref: FuncRef
var dlinear_ref: FuncRef
var tanh_ref: FuncRef
var dtanh_ref: FuncRef

var _func: FuncRef 

var _dfunc: FuncRef

var _ofunc: FuncRef


# Called when the node enters the scene tree for the first time.
func _init(f = relu_ref, of = sigmoid_ref):
	sigmoid_ref = funcref(self, 'sigmoid')
	dsigmoid_ref = funcref(self, "dsigmoid")
	relu_ref = funcref(self, "relu")
	drelu_ref = funcref(self, "drelu")
	lrelu_ref = funcref(self, "lrelu")
	dlrelu_ref = funcref(self, "dlrelu")
	elu_ref = funcref(self, "elu")
	delu_ref = funcref(self, "delu")
	softmax_ref = funcref(self, "softmax")
	linear_ref = funcref(self, "linear")
	dlinear_ref = funcref(self, "dlinear")
	tanh_ref = funcref(self, "htan")
	dtanh_ref = funcref(self, "der_htan")
	
	if f is String:
		match f:
			"sigmoid":
				_func = sigmoid_ref
				_dfunc = dsigmoid_ref
			"relu":
				_func = relu_ref
				_dfunc = drelu_ref
			"elu":
				_func = elu_ref
				_dfunc = delu_ref
			"leaky relu":
				_func = lrelu_ref
				_dfunc = dlrelu_ref
			"lrelu":
				_func = lrelu_ref
				_dfunc = dlrelu_ref
			"tanh":
				_func = tanh_ref
				_dfunc = dtanh_ref
			"htan":
				_func = tanh_ref
				_dfunc = dtanh_ref
			"linear":
				_func = linear_ref
				_dfunc = dlinear_ref
		match of:
			"sigmoid":
				_ofunc = sigmoid_ref
			"relu":
				_ofunc = relu_ref
			"tanh":
				_ofunc = tanh_ref
			"linear":
				_ofunc = linear_ref
	else:
		_func = sigmoid_ref
		_dfunc = dsigmoid_ref
		_ofunc = sigmoid_ref


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func sigmoid(x):
	return 1 / (1 + exp(-x))

func dsigmoid(y):
	return y * (1 - y)


# Hyperbolic Tangent (htan) Activation Function
func htan(x):
	return tanh(x)

# htan derivative
func der_htan(x):
	return 1 - x * x

func relu(x):
	return max(0, x)


func drelu(x):
	var y = 0
	if x > 0:
		y = 1
	elif x <= 0:
		y = 0
	
	return y


func lrelu(x):
	return max(0.01 * x, x)

func dlrelu(x):
	var y = 0.01
	if x >= 0:
		y = 1
	elif x < 0:
		y = 0.01
	
	return y


func elu(x):
	var y = 0
	if x > 0:
		y = x
	if x < 0:
		y = 0.2 * (exp(x) - 1)
	
	return y

func delu(x):
	var y = 1
	if x > 0:
		y = 1
	if x <= 0:
		y = x + 0.2
	
	return y

func softmax(x):
	var e = exp(x)
	return e / sum(e)

static func sum(array):
	var sum = 0.0
	for element in array:
		 sum += element
	return sum

func linear(x):
	return 0.1 * x


func dlinear(x):
	return 0.1

