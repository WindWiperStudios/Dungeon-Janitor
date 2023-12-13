extends TileMap
class_name AStar_Path

@onready var astar : AStar2D = AStar2D.new()
@onready var usedCells = get_used_cells(0)

var path : PackedVector2Array

func _ready():
	_addPoints()
	_connectPoints()

func _addPoints():
	for cell in usedCells:
		astar.add_point(id(cell), cell, 1.0)

func _connectPoints():
	for cell in usedCells:
		#Right, left, down up
		var neighbors = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
		for neighbor in neighbors:
			var nextCell = cell + neighbor
			if usedCells.has(nextCell):
				astar.connect_points(id(cell), id(nextCell), false)

func _getPath(start, end):
	path = astar.get_point_path(id(start), id(end))
	path.remove_at(0)

func id(point):
	var a = point.x
	var b = point.y
	return ((a + b) * (a + b + 1) / 2 + b) + 150
