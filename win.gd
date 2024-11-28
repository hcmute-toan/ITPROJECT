extends Control
@onready var Rank=$RichTextLabel
@onready var Kill=$RichTextLabel2
@onready var Coin=$RichTextLabel3
@onready var gamemager=get_node("/root/Gamemanager")
var coin
var kill
var points
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pointsCaculator()
	Kill.text="[center][wave amp=50 freq=2][color=black]"+"Monster killed:"+str(kill)+"[/color][/wave]"
	Coin.text="[center][wave amp=50 freq=2][color=black]"+"Coin collected:"+str(coin)+"[/color][/wave]"
	Rank.text="[center][wave amp=50 freq=2][color=black]"+"Final points:"+str(points)+"[/color][/wave]"
	pass # Replace with function body.
	
func pointsCaculator():
	coin=gamemager.coins_collected
	kill=gamemager.number_of_enemy_killed
	points=kill*100+coin*10
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_retry_button_button_down() -> void:
	get_tree().change_scene_to_file("res://world.tscn")
	pass # Replace with function body.


func _on_quitbutton_button_up() -> void:
	get_tree().quit()
	pass # Replace with function body.
