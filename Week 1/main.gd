extends Spatial

export(int) var chunk_size = 24
export(int) var refresh_triggger = 4

var chunk = load("res://chunk.tscn")

var noise_color
var noise_height

var chunks = {}
var create_chunks = []

func _ready():
	# Instantiate
	noise_color = OpenSimplexNoise.new()
	noise_height = OpenSimplexNoise.new()
	
	# Configure
	noise_color.seed = randi()
	noise_color.octaves = 4
	noise_color.period = 10
	
	noise_height.seed = randi()
	noise_height.octaves = 4
	noise_height.period = 10
	noise_height.lacunarity = 20
	noise_height.persistence = 0.1
	
	create_chunks.append(Vector3(-chunk_size,0,chunk_size))
	create_chunks.append(Vector3(-chunk_size,0,0))
	create_chunks.append(Vector3(-chunk_size,0,-chunk_size))
	
	create_chunks.append(Vector3(0,0,chunk_size))
	create_chunks.append(Vector3(0,0,0))
	create_chunks.append(Vector3(0,0,-chunk_size))
	
	create_chunks.append(Vector3(chunk_size,0,chunk_size))
	create_chunks.append(Vector3(chunk_size,0,0))
	create_chunks.append(Vector3(chunk_size,0,-chunk_size))

func _on_Camera_moved(position):
	$position.text = "Position x: %s, y: %s, z: %s" % [position.x, position.y, position.z]
	
	var chunk_x = int(position.x / chunk_size) * chunk_size
	var chunk_z = int(position.z / chunk_size) * chunk_size
	var chunk_position = Vector3(chunk_x, 0, chunk_z)
	
	var triger_creation_distance = chunk_size / 4
	
	# Left
	if abs(chunk_position.x - position.x) >= triger_creation_distance or abs(chunk_position.x + chunk_size - position.x) >= triger_creation_distance:
		create_chunks.append(Vector3(chunk_position.x - chunk_size, position.y, chunk_position.z - chunk_size))
		create_chunks.append(Vector3(chunk_position.x, position.y, chunk_position.z - chunk_size))
		create_chunks.append(Vector3(chunk_position.x + chunk_size, position.y, chunk_position.z - chunk_size))
	if abs(chunk_position.x - position.x) >= triger_creation_distance or abs(chunk_position.x + chunk_size - position.x) >= triger_creation_distance:
		create_chunks.append(Vector3(chunk_position.x - chunk_size, position.y, chunk_position.z - chunk_size))
		create_chunks.append(Vector3(chunk_position.x, position.y, chunk_position.z - chunk_size))
		create_chunks.append(Vector3(chunk_position.x + chunk_size, position.y, chunk_position.z - chunk_size))
	# Bottom
	if abs(chunk_position.z - position.z) >= triger_creation_distance or abs(chunk_position.z + chunk_size - position.z) >= triger_creation_distance:
		create_chunks.append(Vector3(chunk_position.x - chunk_size, position.y, chunk_position.z - chunk_size))
		create_chunks.append(Vector3(chunk_position.x - chunk_size, position.y, chunk_position.z))
		create_chunks.append(Vector3(chunk_position.x - chunk_size, position.y, chunk_position.z + chunk_size))

func _process(delta):
	for chunk_position in create_chunks:
		if not chunks.get(chunk_position.x):
			chunks[chunk_position.x] = {}
		
		if not chunks[chunk_position.x].get(chunk_position.z):
			var new_chunk = chunk.instance()
			new_chunk.position = chunk_position
			new_chunk.noise_height = noise_height
			new_chunk.noise_color = noise_color
			
			$chunks.add_child(new_chunk)
			
			chunks[chunk_position.x][chunk_position.z] = new_chunk
	
	# fixme: can _on_Camera_moved happen during _process?
	create_chunks = []
