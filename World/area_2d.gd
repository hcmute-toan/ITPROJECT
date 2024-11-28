extends Area2D
func _ready():
	# Kết nối tín hiệu body_entered với phương thức _on_Area2D_body_entered
	connect("body_entered", Callable(self, "_on_Area2D_body_entered"))

func _on_Area2D_body_entered(body):
	if body.name == "player":  # Chỉ kích hoạt với nhân vật
		# Tạm dừng 0.5 giây trước khi chuyển cảnh
		await get_tree().create_timer(0.5).timeout
		var result = get_tree().change_scene_to_file("res://World/world_2.tscn")
		if result != OK:
			print("Failed to change scene: ", result)
