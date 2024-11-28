extends Area2D
@onready var player=get_node("../player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
# AreaDetector.gd

	# Connect signals for when other bodies enter or exit the area
	


# Called when a body enters the area

func _on_body_entered(body):
	if body.name=="player":
		var new_scene = load("res://Winner.tscn")
		get_tree().change_scene_to_packed(new_scene)

# Called when a body exits the area
