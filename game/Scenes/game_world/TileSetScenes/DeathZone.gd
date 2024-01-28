class_name DeathTile
extends Node2D

signal death_entered(_body: Node2D)

func _on_area_2d_body_entered(_body: Node2D):
	death_entered.emit(_body)
