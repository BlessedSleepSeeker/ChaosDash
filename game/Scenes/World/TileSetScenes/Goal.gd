class_name GoalTile
extends Node2D

signal goal_reached(_body:Node2D)

func _on_area_2d_body_entered(_body: Node2D):
	goal_reached.emit(_body)
