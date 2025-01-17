class_name MiniJoypad extends Node2D

var width:int = 128
var inner_width:int = 32
var center:Vector2
var center_indicator:Vector2

func _ready() -> void:
	center = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width") / 2,
		ProjectSettings.get_setting("display/window/size/viewport_height") / 2
	)

func _process(delta):
	center_indicator = Vector2(
		center.x + (width - inner_width) * Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
		center.y + (width - inner_width) * Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	)
	queue_redraw()

func _draw() -> void:
	draw_unfilled_circle(center, width, Color.WHITE)
	draw_unfilled_circle(center_indicator, inner_width, Color.WHITE)

func draw_unfilled_circle(center:Vector2, radius:float, color:Color) -> void:
	var nb_points:int = 32
	var points_arc:Array = PackedVector2Array()
	for i in range(nb_points + 1):
		var angle_point:float = deg_to_rad(0 + i * 360.0 / nb_points - 90.0)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)
