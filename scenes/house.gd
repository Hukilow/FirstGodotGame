extends Node2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	Global.inCollision.append(area)


func _on_area_2d_area_exited(area: Area2D) -> void:
	Global.inCollision.erase(area)
