extends ParallaxBackground

@export var scrolling_speed: int = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("Should Be Running", Time.get_ticks_msec())
	scroll_offset.x -= scrolling_speed * delta
