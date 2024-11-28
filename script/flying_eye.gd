extends CharacterBody2D
class_name EyeEnemy
@onready var healthbar=$Healthbar
const speed = 50
var dir : Vector2
var is_bat_chase : bool

var player : CharacterBody2D

var health = 50
var health_max = 50
var health_min = 0
var dead = false
var taking_damage = false
var is_roaming : bool
var damage_to_deal = 20

func _ready():
	is_bat_chase = true
	healthbar.init_health(health)

var can_attack = true

func attack_player():
	if global.playerAlive and !dead and can_attack:
		if $BatDealDamageArea.overlaps_area(global.playerDamageZone):
			print("Quái nhận sát thương, máu còn lại: ", global.playerHealth)  # Debug line
			global.playerHealth -= damage_to_deal
			global.playerDamageTaken = true

			# Kiểm tra nếu người chơi đã chết
			if global.playerHealth <= 0:
				global.playerHealth = 0
				global.playerAlive = false
				print("Nguoi choi da chet")
		
		can_attack = false  # Đảm bảo không tấn công liên tiếp ngay lập tức
		
		# Đặt lại can_attack sau một khoảng thời gian để cho phép tấn công lại
		await get_tree().create_timer(0.5).timeout
		can_attack = true

	
func _process(delta: float) -> void:
	global.batDamageAmount = damage_to_deal
	global.batDamageZone = $BatDealDamageArea
	
	if global.playerAlive:
		is_bat_chase = true
	elif !global.playerAlive:
		is_bat_chase = false
	
	if is_on_floor() and dead:
		await get_tree().create_timer(1.0).timeout
		self.queue_free()
		
	move(delta)
	handle_animation()
	attack_player()

func move(delta):
	player = global.playerBody
	if !dead:
		is_roaming = true
		if !taking_damage and is_bat_chase and global.playerAlive:
			velocity = position.direction_to(player.position) * speed
			dir.x = sign(velocity.x) # Lấy hướng -1 hoặc 1 từ vận tốc
		elif taking_damage:
			var knockback_dir = position.direction_to(player.position) * -50
			velocity = knockback_dir
		else:
			velocity += dir * speed * delta
	elif dead:
		velocity.y += 10 * delta
		velocity.x = 0
	move_and_slide()

func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([0.5, 0.8])
	if !is_bat_chase:
		dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
		print(dir)

func handle_animation():
	var animated_sprite = $AnimatedSprite2D
	if !dead and !taking_damage:
		animated_sprite.play("fly")
		if dir.x == -1:
			animated_sprite.flip_h = true
		elif dir.x == 1:
			animated_sprite.flip_h = false
	elif !dead and taking_damage:
		animated_sprite.play("hurt")
		await get_tree().create_timer(0.8).timeout
		taking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		animated_sprite.play("death")
		set_collision_layer_value(1, true)
		set_collision_layer_value(2, false)
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, false)

func choose(array):
	array.shuffle()
	return array.front()

# Nhận sát thương từ hitbox của nhân vật
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area == global.playerDamageZone:
		var damage = global.playerDamageAmount
		take_damage(damage)

# Hàm để quái nhận sát thương
func take_damage(damage):
	if !dead:
		health -= damage
		healthbar.health=health
		taking_damage = true
		if health <= 0:
			health = 0
			dead = true
			player.kill()

			print("Quái đã chết!")
		else:
			print("Quái nhận sát thương, máu còn lại: ", health)
			
