extends Node
@onready var CoinlBl=$CanvasLayer/RichTextLabel
@onready var KilllBl=$CanvasLayer/RichTextLabel2
# Variable to count the number of coins collected
var coins_collected: int = 0
var number_of_enemy_killed : int = 0
# Called when the node enters the scene tree
func _ready() -> void:
	CoinlBl.text="[color=yellow]Coins:"
	KilllBl.text="[color=yellow]Enemies defeated:"
	print("Game Manager initialized. Coins collected:", coins_collected)

# Function to increment the coin count
func add_coin() -> void:
	coins_collected += 1
	CoinlBl.text="[color=yellow]Coins:"+str(coins_collected)
	print("Coin collected! Total coins:", coins_collected)
func add_kill(kill)->void:
	number_of_enemy_killed+=kill
	KilllBl.text="[color=yellow]Enemies defeated:"+str(number_of_enemy_killed)
	print(number_of_enemy_killed)
