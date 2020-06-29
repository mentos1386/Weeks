extends Camera

export var flyspeed= 15
var yaw = 0
var pitch = 0
var view_sensitivity = 0.25

signal moved(position)

func _enter_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event is InputEventMouseMotion:
		yaw = fmod(yaw - event.relative.x * view_sensitivity, 360)
		pitch = max(min(pitch - event.relative.y * view_sensitivity, 85), -85)
		self.set_rotation(Vector3(deg2rad(pitch), deg2rad(yaw), 0))

func _process(delta):
	if(Input.is_key_pressed(KEY_W)):
		self.move(self.get_translation() - get_global_transform().basis*Vector3(0,0,1) * flyspeed * .01)
	if(Input.is_key_pressed(KEY_S)):
		self.move(self.get_translation() - get_global_transform().basis*Vector3(0,0,1) * flyspeed * -.01)
	if(Input.is_key_pressed(KEY_A)):
		self.move(self.get_translation() - get_global_transform().basis*Vector3(1,0,0) * flyspeed * .01)
	if(Input.is_key_pressed(KEY_D)):
		self.move(self.get_translation() - get_global_transform().basis*Vector3(1,0,0) * flyspeed * -.01)

func move(position):
	self.set_translation(position)
	emit_signal("moved", self.translation)
