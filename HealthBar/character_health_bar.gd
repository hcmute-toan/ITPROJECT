extends ProgressBar
@onready var timer=$Timer
@onready var damagebar=$ProgressBar
@onready var player=get_node("../../player")
# Called when the node enters the scene tree for the first time.
var current
var i=0

func _ready():
	player.damages.connect(update)
	update()
func update():
	value=player.health*100/player.health_max
	if value==0:
		queue_free()
	if i==0:
		damagebar.value=100
		i+=1

	timer.start()



func _on_timer_timeout():
	damagebar.value=value # Replace with function body.
