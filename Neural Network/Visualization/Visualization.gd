extends Node2D

export var sprite_texture: Texture
export var display_bias: bool = false
export var y_separation: float = 100.0
export var x_separation: float = 200.0
export var positive_color: Color = Color.blue
export var negative_color: Color = Color.red
export var zero_color: Color = Color.black
export var min_color_threshold = -1.0 #the value inside the matrix at which we color the line 100% negative
export var max_color_threshold = 1.0 #the value inside the matrix at which we color the line 100% positive
export var min_line_width: float = 3.0
export var max_line_width: float = 12.0
export var min_width_threshold = 0.0 #the value inside the matrix at which the line will be of min_line_width px wide
export var max_width_threshold = 3.0 #the value inside the matrix at which the line will be of max_line_width px wide
export var dead_weight_threshold = -0.005
export var dead_weight_line_width = 1.0


#nn.input_nodes = int, #of input nodes
#nn.hidden_nodes = array of ints, #of hidden nodes per layer
#nn.output_nodes = int, #of output nodes
#nn.layer = array of dicts
# { "weights": array,
#   "bias": array,
# }

#generate sprites of nn.hidden_nodes
#for each layer generate sprites of count weights.size()
#with weights set to weights[j]
#generate sprites of nn.output_nodes
var line = Line2D.new()
var sp = Sprite.new()

func visualize(nn):
	clear()
	add_child(sp)
	add_child(line)
	line.hide()
	sp.hide()
	sp.texture = sprite_texture
	var anchor = sp.position
	var head_pts = []
	var tail_pts = []

	var max_node_height = _get_max_node_height(nn)

	for j in nn.input_nodes:
		var d = sp.duplicate()
		var y_margin = (max_node_height - nn.input_nodes) * y_separation / 2.0
		d.position.y = j * y_separation + anchor.y + y_margin
		add_child(d)
		d.show()
		head_pts.append(d.position)
	#nn = nn as NeuralNetwork
	for i in nn.layer.size():
		var layer = nn.layer[i]

		sp.position.x = (i + 1) * x_separation + anchor.x
		var weights
		var node_count
		if layer["weights"] is Matrix:
			weights = layer["weights"].to_array(true)
			node_count = weights.size()

		else:
			node_count = layer["weights"].size()
			weights = layer["weights"]

		var y_margin = (max_node_height - node_count) * y_separation / 2.0
		for j in node_count:
			var d = sp.duplicate()
			if display_bias:
				
				var valB = layer["bias"].to_array(true)[j][0]
				var color_ratioB = range_lerp(valB, min_color_threshold, max_color_threshold, 0.0, 1.0)
				d.modulate = lerp(Color.black, Color.white, color_ratioB)
				d.name = str(valB)
			d.position.y = j * y_separation + anchor.y + y_margin
			add_child(d)
			d.show()
			tail_pts.append(d.position)

			for h in head_pts.size():
				for t in tail_pts.size():
					var val = weights[t][h]
					var color_ratio = range_lerp(val, min_color_threshold, max_color_threshold, 0.0, 1.0)
					var l = line.duplicate()
					l.points = PoolVector2Array([head_pts[h],tail_pts[t]])
					if abs(val) < dead_weight_threshold:
						l.default_color = zero_color
						l.width = dead_weight_line_width
					else:
						var width = abs(val)
						width = range_lerp(width, min_width_threshold, max_width_threshold, min_line_width, max_line_width)
						l.width = clamp(width, min_line_width, max_line_width)
						l.default_color = lerp(negative_color, positive_color, color_ratio)

					l.show_behind_parent = true
					l.name = "Line" + String(i) + "-" + String(j)

					add_child(l)
					l.show()

		head_pts = tail_pts.duplicate(true)
		tail_pts.clear()

func _get_max_node_height(nn):
	var max_node_count: int = 0
	for layer in nn.layer:
		var layer_size: int = 0
		if layer["weights"] is Matrix:
			layer_size = layer["weights"].to_array(true).size()
		else:
			layer_size = layer["weights"].size()

		max_node_count = max(layer_size, max_node_count)

	return max_node_count

func clear():
	sp.queue_free()
	line.queue_free()
	for n in get_children():
		n.queue_free()
