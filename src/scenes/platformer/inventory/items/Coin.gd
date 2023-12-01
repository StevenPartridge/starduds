extends Node


func _on_area_2d_area_entered(body):
	print("HEPYA")
	if body.has_method("collect_coin"):
		body.collect_coin()
		queue_free()
