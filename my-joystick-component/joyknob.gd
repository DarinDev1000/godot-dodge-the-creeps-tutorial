extends Sprite2D

@onready var parent: Joystick = $".."

var pressing = false
var outside_deadzone = false

@export var maxLength = 50
@export var deadzone = 10

func _ready() -> void:
	maxLength *= parent.scale.x

func _process(delta: float) -> void:
	var outVector: Vector2 = Vector2.ZERO
	if pressing:
		if get_global_mouse_position().distance_to(parent.global_position) <= maxLength:
			global_position = get_global_mouse_position()
		else:
			var angle = parent.global_position.angle_to_point(get_global_mouse_position())
			global_position.x = parent.global_position.x + cos(angle)*maxLength
			global_position.y = parent.global_position.y + sin(angle)*maxLength
			
		outVector = calculateVector()
	else:
		global_position = lerp(global_position, parent.global_position, delta*50)
		outVector = Vector2(0,0)
		outside_deadzone = false
		
	parent.posVector = outVector
	#print(parent.posVector)
	doInputToMap()

func calculateVector() -> Vector2:
	var moveVector: Vector2 = Vector2.ZERO
	if abs(global_position.x - parent.global_position.x) >= deadzone:
		moveVector.x = (global_position.x - parent.global_position.x)/maxLength
	if abs(global_position.y - parent.global_position.y) >= deadzone:
		moveVector.y = (global_position.y - parent.global_position.y)/maxLength
	return moveVector

func doInputToMap():
	var inputDirection: Vector2 = parent.posVector
	var normalized_vector = inputDirection.normalized().snapped(Vector2.ONE)
	
	if abs(global_position.x - parent.global_position.x) >= deadzone && abs(global_position.x - parent.global_position.x) >= deadzone:
		outside_deadzone = true
	
	Input.action_release("ui_up")
	Input.action_release("ui_down")
	Input.action_release("ui_left")
	Input.action_release("ui_right")
	#Input.action_release("move_up")
	#Input.action_release("move_down")
	#Input.action_release("move_left")
	#Input.action_release("move_right")
	
	if outside_deadzone:
		InputEventJoypadMotion.new()
		if normalized_vector == Vector2.RIGHT:
			Input.action_press("ui_right")
			#Input.action_press("move_right")
		elif normalized_vector == Vector2.LEFT:
			Input.action_press("ui_left")
			#Input.action_press("move_left")
		elif normalized_vector == Vector2.UP:
			Input.action_press("ui_up")
			#Input.action_press("move_up")
		elif normalized_vector == Vector2.DOWN:
			Input.action_press("ui_down")
			#Input.action_press("move_down")



func _on_button_button_down() -> void:
	pressing = true
	


func _on_button_button_up() -> void:
	pressing = false
