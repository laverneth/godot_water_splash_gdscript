tool
extends Node2D


export var nb_tiles = 10 setget _set_nb_tiles
export var width = 32 setget _set_width
export var height = 64 setget _set_height
export var draw_color = Color(0.63,0.79,0.8, 0.2) setget _set_color
export (Texture) var texture setget _set_texture

export var damping = 0.05
export var tension = 0.05
export var spread = 0.05
export var drag = Vector2(0.05,0.03)


var water_columns = []


# This is the definition of a water column
class WaterColumn extends Area2D :
	var height_
	var target_height_
	var speed_
	var drag_ = Vector2()
	#when a body enters the water column
	func plouf(var body):
		if body is RigidBody2D:
			var v = body.linear_velocity
			speed_ = drag_.x*abs(v.x)+drag_.y*abs(v.y)
	# Recompute speed and height of a water column
	func refresh(var tension, var damping):
		var dh = target_height_ - height_
		speed_ += tension*dh -damping*speed_
		height_ += speed_

func _set_texture(value):
	texture = value
	reset_water_columns()

func _set_color(value):
	draw_color = value
	reset_water_columns()

func _set_nb_tiles(value):
	nb_tiles = value
	reset_water_columns()

func _set_width(value):
	width = value
	reset_water_columns()

func _set_height(value):
	height = value
	reset_water_columns()

func reset_water_columns():
	for c in water_columns:
		remove_child(c)
	water_columns.clear()
	var x = 0
	for i in range(0, nb_tiles):
		#Initialize water column
		var column = WaterColumn.new()
		column.position.x = x+0.5*width
		column.position.y = 0.5*height
		column.height_ = height
		column.target_height_ = height
		column.speed_ = 0
		column.drag_ = drag
		#Make collision shape
		var collision_shape = CollisionShape2D.new();
		var shape = RectangleShape2D.new()
		shape.set_extents(Vector2(0.5*width, 0.5*height))
		collision_shape.set_shape(shape)
		column.add_child(collision_shape)
		add_child(column)
		column.connect("body_entered", column,  "plouf")
		column.set_collision_mask_bit(0, true)
		water_columns.append(column)
		x += width

func update_water_columns():
	var lh = PoolRealArray()
	lh.resize(nb_tiles)
	var rh = PoolRealArray()
	rh.resize(nb_tiles)
	# recompute "speed" for each water column
	for c in water_columns:
		c.refresh(tension, damping)

	# few iterations of smoothing...
	for iter in range(0,9) :
		for i in range(0, nb_tiles):
			if(i>0):
				lh[i] = spread*(water_columns[i].height_-water_columns[i-1].height_)
				water_columns[i-1].speed_ += lh[i]
			if(i<nb_tiles-2):
				rh[i] = spread*(water_columns[i].height_-water_columns[i+1].height_)
				water_columns[i+1].speed_ += rh[i]
		for i in range(0, nb_tiles):
			if(i>0):
				water_columns[i-1].height_ += lh[i]
			if(i<nb_tiles-2):
				water_columns[i+1].height_ += rh[i]


func _draw():
	var x = 0
	var colors = PoolColorArray()
	colors.append(draw_color)
	colors.append(draw_color)
	colors.append(draw_color)
	colors.append(draw_color)
	var uvs = PoolVector2Array()
	uvs.append(Vector2(1,1))
	uvs.append(Vector2(1,0))
	uvs.append(Vector2(0,0))
	uvs.append(Vector2(0,1))
	
	# in Editor...
	if( Engine.editor_hint):
		var y = height
		for i in range(0, nb_tiles):
			var pts = PoolVector2Array()
			pts.append(Vector2(x,y))
			pts.append(Vector2(x, y))
			pts.append(Vector2(x+width, y))
			pts.append(Vector2(x+width,y))
			draw_polygon(pts, colors, uvs, texture)
			x += width
	# in Game...
	else:
		update_water_columns()
		# Compute average height between columns...
		var heights = []
		heights.append(height)
		for i in range(0, nb_tiles-1):
			heights.append(max(0.01,0.5*(water_columns[i].height_+water_columns[i+1].height_)))
		heights.append(height)
		# draw polygons joining columns...
		var y = height
		for i in range(0, nb_tiles):
			var pts = PoolVector2Array()
			pts.append(Vector2(x,y))
			pts.append(Vector2(x, y-heights[i]))
			pts.append(Vector2(x+width, y-heights[i+1]))
			pts.append(Vector2(x+width,y))
			draw_polygon(pts, colors, uvs, texture)
			x += width

func _process(_delta):
	update()
