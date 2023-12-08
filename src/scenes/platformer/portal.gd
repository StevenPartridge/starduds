extends Node2D

@export var teleport_to: String = "Main"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(body):
	if !visible: return
	if body.has_method("teleport_to"):
		body.teleport_to(teleport_to)



func _on_area_2d_body_entered(body):
	if !visible: return
	if body.has_method("gravity_to"):
		body.gravity_to(position.x, position.y)
