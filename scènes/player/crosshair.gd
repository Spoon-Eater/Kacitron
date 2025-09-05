extends CenterContainer

@export var crossshair = true
@export var dot_radius: float
@export var dot_color: Color = Color.WHITE
@export var dot_outline: bool = true
@export var dot_outline_radius: float
@export var dot_outline_color: Color = Color.BLACK

var _show_option = true

func _ready():
	if crossshair == false: _show_option = false
	queue_redraw()

@rpc("call_local")
func _show(trigger : bool):
	if _show_option:
		crossshair = !trigger
		queue_redraw()

func _draw():
	if crossshair:
		if dot_outline == true:
			draw_circle(Vector2(0, 0), dot_outline_radius, dot_outline_color)
		draw_circle(Vector2(0, 0), dot_radius, dot_color)
