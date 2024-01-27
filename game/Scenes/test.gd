extends Node2D

@onready var tilemap = $TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	for chil in tilemap.get_children():
		chil.goal_reached.connect(_prout)

func _prout(_body: Node2D):
	print("uoiuii")
