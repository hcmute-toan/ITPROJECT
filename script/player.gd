extends CharacterBody2D
class_name Player
signal damages()
@onready var animated_sprite = $AnimatedSprite2D
@onready var deal_damage_zone = $DealDamageZone
@onready var gamemanager=get_node("/root/Gamemanager")
const speed = 200
const jump_power = -350.0
var gravity = 900
var prev_killed=0
var attack_type : String
var current_attack : bool 
var weapon_equip : bool

var health = 200
var health_max = 200
var health_min = 0
var can_take_damage : bool
var dead : bool
var killed=0
func _ready() -> void:
	global.playerBody = self
	current_attack = false
	dead = false
	can_take_damage = true
	global.playerAlive = true

	deal_damage_zone.get_node("CollisionShape2D").disabled = true


func _physics_process(delta: float) -> void:
	# Add gravity

	if not is_on_floor():
		velocity.y += gravity * delta
		
	if !dead:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_power
			
		# Horizontal movement
		var direction := Input.get_axis("left", "right")
		if direction != 0:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			
		weapon_equip = global.playerWeaponEquip
		global.playerDamageZone = deal_damage_zone
		global.playerHitbox = $PlayerHitbox
		
		if weapon_equip and not current_attack:
			if Input.is_action_just_pressed("left_mouse") or Input.is_action_just_pressed("right_mouse") or Input.is_action_just_pressed("attack_single") or Input.is_action_just_pressed("attack_double"):
				current_attack = true
			if (Input.is_action_just_pressed("left_mouse") or Input.is_action_just_pressed("attack_single")) and is_on_floor():
				attack_type = "single"
			elif (Input.is_action_just_pressed("right_mouse") or Input.is_action_just_pressed("attack_double")) and is_on_floor():
				attack_type = "double"
			else:
				attack_type = "air"
				
			set_damage(attack_type)
			handle_attack_animation(attack_type)
		handle_movement_animation(direction)
		check_hitbox()
	# Apply movement
	if dead==false:
		move_and_slide()

func check_hitbox():
	if !deal_damage_zone.get_node("CollisionShape2D").disabled:
		return # Không kiểm tra nếu vùng sát thương của người chơi bị vô hiệu hóa
		
	var hitbox_areas = $PlayerHitbox.get_overlapping_areas()
	if hitbox_areas:
		for hitbox in hitbox_areas:
			if hitbox.get_parent() is EyeEnemy:
				# Kiểm tra nếu nhân vật đang tấn công, thì không nhận sát thương
				if current_attack:
					return  # Nếu đang tấn công thì không nhận sát thương
				var damage = global.batDamageAmount
				if can_take_damage:
					take_damage(damage)
		
				break # Dừng kiểm tra sau khi xử lý một hitbox
			if hitbox.get_parent() is Mushroom:
				if current_attack:
					return
				var damage = global.msDamageAmount
				if can_take_damage:
					take_damage(damage)
		
				break
			if hitbox.get_parent() is Skeleton:
				if current_attack:
					return
				var damage = global.skDamageAmount
				if can_take_damage:
					take_damage(damage)
			
				break
			if hitbox.get_parent() is Goblin:
				if current_attack:
					return
				var damage = global.gbDamageAmount
				if can_take_damage:
					take_damage(damage)
	
				break
				
func take_damage(damage: int):
	if damage <=0 or dead:
		return # Không nhận sát thương nếu đã chết hoặc sát thương ko hợp lệ 
		
	health -= damage
	damages.emit()
	
	if health <= 0:
		health = 0
		handle_death()
		#cho them code game over screen
	else:
		start_damage_cooldown(1.0) # Không cho nhận sát thương trong 1 giây
		

	
func handle_death():
	if dead :
		return
	dead = true
	global.playerAlive = false
	animated_sprite.play("death")
	print("Player has died!")
	wait_and_execute(3,gameover)
	# Lấy vị trí của nhân vật để giữ camera tại đó
	var camera_node = get_node("Camera2D")
	if camera_node:
		camera_node.make_current() # Tắt theo dõi nhân vật
		camera_node.global_position = global_position # Đặt camera tại vị trí hiện tại của nhân vật
		
		## Nếu camera có giới hạn, giữ nguyên các giá trị giới hạn
		camera_node.zoom = camera_node.zoom # Giữ tỷ lệ phóng to/thu nhỏ hiện tại
		update_camera_limits(camera_node)
		#camera_node.limit_left = camera_node.limit_left
		#camera_node.limit_right = camera_node.limit_right
		#camera_node.limit_top = camera_node.limit_top
		#camera_node.limit_bottom = camera_node.limit_bottom
	#Đợi kết thúc hoạt ảnh chết và xóa nhân vật
	await get_tree().create_timer(2.5).timeout
	#self.queue_free()
	
func update_camera_limits(camera_node: Camera2D) -> void:
	# Tính toán giới hạn mới theo zoom
	var zoom_factor = camera_node.zoom
	camera_node.limit_left *= zoom_factor.x
	camera_node.limit_right *= zoom_factor.x
	camera_node.limit_top *= zoom_factor.y
	camera_node.limit_bottom *= zoom_factor.y
func start_damage_cooldown(wait_time: float):
	can_take_damage = false
	await get_tree().create_timer(wait_time).timeout
	can_take_damage = true
		
func take_damage_cooldown(wait_time):
	can_take_damage = false
	await get_tree().create_timer(wait_time).timeout
	can_take_damage = true
	
func handle_movement_animation(dir: float) -> void:
	if !weapon_equip:
		if is_on_floor():
			if velocity.x == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
				toggle_flip_sprite(dir)
		else:
			animated_sprite.play("fall")
	else:
		if is_on_floor() and !current_attack:
			if velocity.x == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
				toggle_flip_sprite(dir)
		elif !is_on_floor() and !current_attack:
			animated_sprite.play("fall")

func toggle_flip_sprite(dir: float) -> void:
	if dir == 1:
		animated_sprite.flip_h = false
		deal_damage_zone.scale.x = 1
	elif dir == -1:
		animated_sprite.flip_h = true
		deal_damage_zone.scale.x = -1

func handle_attack_animation(attack_type: String) -> void:
	if weapon_equip and current_attack:
		var animation = attack_type + "_attack"
		animated_sprite.play(animation)
		
		var wait_time_start : float
		var wait_time_end : float
		
		match attack_type:
			"air":
				wait_time_start = 0.2
				wait_time_end = 0.6
			"single":
				wait_time_start = 0.1
				wait_time_end = 0.3
			"double":
				wait_time_start = 0.2
				wait_time_end = 0.5
		#Bật hoạt ảnh khi bắt đầu tấn công
		toggle_damage_collisions(true, wait_time_start)
		#Tắt hoạt ảnh khi tấn công kết thúc
		toggle_damage_collisions(false, wait_time_end)
		
		var total_animation_time = wait_time_end + 0.2
		await  get_tree().create_timer(total_animation_time).timeout
		current_attack = false

func toggle_damage_collisions(enable: bool, wait_time: float) -> void:
	await get_tree().create_timer(wait_time).timeout
	var damage_zone_collision = deal_damage_zone.get_node("CollisionShape2D")
	if damage_zone_collision:
		damage_zone_collision.disabled = not enable #Đúng cách để bật/tắt va chạm
	
	if enable:
		can_take_damage = false
	else:
		can_take_damage = true

func _on_animated_sprite_animation_finished() -> void:
	if animated_sprite.animation in ["single_attack", "double_attack", "air_attack"]:
		current_attack = false
		deal_damage_zone.get_node("CollisionShape2D").disabled = true
		

func set_damage(attack_type: String) -> void:
	var current_damage_to_deal: int
	match attack_type:
		"single":
			current_damage_to_deal = 8
		"double":
			current_damage_to_deal = 16
		"air":
			current_damage_to_deal = 20
	global.playerDamageAmount = current_damage_to_deal
func instantDeath():
	health=0
	global.playerAlive = false
	animated_sprite.play("death")
	dead=true
	wait_and_execute(3,gameover)
func hide_all_nodes(parent: Node):
	await (5)
	for child in parent.get_children():
		if not (child is AudioStreamPlayer):
			child.visible=false
		
func gameover():
	change_scene("res://GameOver.tscn")
	
func wait_and_execute(seconds: float, command: Callable):
	var timer = Timer.new()  # Create a new Timer instance
	add_child(timer)  # Add the timer to the scene tree
	timer.wait_time = seconds  # Set the wait time
	timer.one_shot = true  # Make it a one-shot timer
	timer.start()  # Start the timer
	await timer.timeout  # Wait for the timer to timeout
	command.call()  # Execute the command
func change_scene(new_scene_path: String):
	var new_scene = load(new_scene_path)
	get_tree().change_scene_to_packed(new_scene)
func kill():
	if killed==0:
		killed+=1
		gamemanager.add_kill(1)
	else:
		prev_killed=killed
		killed+=1
		gamemanager.add_kill(1)
