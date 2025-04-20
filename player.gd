class_name Player
extends CharacterBody2D

@export var speed := 200.0

@onready var icon: Sprite2D = $Icon as Sprite2D
@onready var item_name: String = ""
@onready var item_icon: Sprite2D = $ItemIcon as Sprite2D
@onready var food_scene: PackedScene = preload("res://food.tscn")

@onready var down_texture: Texture2D = preload("res://figarro_down_idle.png")
@onready var up_texture: Texture2D = preload("res://figarro_up_idle.png")
@onready var left_texture: Texture2D = preload("res://figarro_left_idle.png")
@onready var right_texture: Texture2D = preload("res://figarro_right_idle.png")

var activatables: Array[Activatable]
var input := Vector2.ZERO
var bounce := 0.0

func _process(delta: float) -> void:
	Globals.game_time += delta
	input = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	if input.y == -1:
		icon.texture = up_texture
	elif input.y == 1:
		icon.texture = down_texture
	elif input.x == -1:
		icon.texture = left_texture
	elif input.x == 1:
		icon.texture = right_texture
	icon.position.y = sin(bounce / 6) * 5
	item_icon.position.y = sin(bounce / 6) * 5 - 60
	if Input.is_action_just_pressed("activate"):
		for i in range(0, activatables.size()):
			var activatable := activatables[i].activate(self)
			if activatable:
				update_prompt()
				break
			else:
				activatables[i].set_display(false)
	elif Input.is_action_just_pressed("drop") and item_name != "":
		var food: Food = food_scene.instantiate() as Food
		food.init(item_name)
		food.global_position = global_position
		get_parent().add_child(food)
		item_name = ""
		item_icon.visible = false

func _physics_process(delta: float) -> void:
	var pos := position
	position += input * speed * delta
	move_and_slide()
	var distance := (position - pos).length()
	bounce += distance

func update_prompt():
	for activatable in activatables:
		if activatable.can_activate(self):
			activatable.set_display(true)
			return
		activatable.set_display(false)
	Globals.set_prompt_display.emit("")
