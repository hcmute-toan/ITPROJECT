# AreaDetector.gd
extends Area2D
@onready var player=get_node("../player")
# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Connect signals for when other bodies enter or exit the area
	self.body_entered.connect(_on_body_entered)


# Called when a body enters the area
func _on_body_entered(body):
	if body.name=="player":
		print(player)
		print(player.health)
		player.instantDeath()


# Called when a body exits the area
