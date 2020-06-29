extends StaticBody

export(Color) var color = Color(1,1,1,1)

func _ready():
	var material = SpatialMaterial.new()
	material.albedo_color = color
	$collision/mesh.material_override = material
