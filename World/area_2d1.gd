extends Area2D

func _ready():
	# Kết nối tín hiệu body_entered với phương thức _on_Area2D_body_entered
	connect("body_entered", Callable(self, "_on_Area2D_body_entered"))

func _on_Area2D_body_entered(body):
		get_tree().change_scene_to_file("res://World/world3.tscn")  # Đảm bảo đường dẫn đúng
