tool

extends Spatial

export(int) var size = 24
export(int) var min_height = 1
export(int) var max_height = 24

var voxel = load("res://voxel.tscn")

var noise_height: OpenSimplexNoise
var noise_color: OpenSimplexNoise
var position: Vector3

func to_scale(min_value, max_value, value):
	var deltaA = 1 - -1
	var deltaB = max_value - min_value
	var scale = deltaB / deltaA
	return round(value * scale + scale + 1)

func _ready():
	for x in range(position.x, position.x + size):
		for z in range(position.z, position.z + size):
			var y = to_scale(min_height, max_height, noise_height.get_noise_2d(x, z))

			var v = voxel.instance()
			v.translate(Vector3(x, y, z))
			
			v.color = Color("#347AA8")
			if y > 4:
				v.color = Color("64BBF5")
			if y > 6:
				v.color = Color("#F5F34C")
			if y > 8:
				v.color = Color("#F57E7D")
			
			v.color.s = to_scale(0, 10, noise_color.get_noise_2d(x, z)) / 10

			add_child(v)
