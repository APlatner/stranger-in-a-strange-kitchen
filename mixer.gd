class_name Mixer
extends Activatable

@onready var recipes: Array[Recipe] = [
	Recipe.new("Cake Batter", ["Flour", "Sugar", "Milk"]),
	Recipe.new("Pie Crust", ["Flour", "Water", "Butter"]),
	Recipe.new("Pizza Crust", ["Flour", "Water", "Yeast"]),
	Recipe.new("Frosting", ["Butter", "Sugar"]),
]
@onready var current_recipes: Array[Recipe] = recipes.duplicate()
@onready var food_scene: PackedScene = preload("res://food.tscn") as PackedScene

@onready var ingredients: Array[String] = []

var running := false
var runtime := 0.0
var mixtime := 10.0

func _process(delta: float):
	if running:
		runtime += delta
		$ProgressBar.value = runtime / mixtime  * 100
	if runtime >= mixtime:
		var food: Food = food_scene.instantiate() as Food
		food.init(current_recipes[0].product)
		food.global_position = global_position + Vector2.DOWN * 100
		get_parent().add_child(food)
		runtime = 0.0
		running = false
		ingredients = []
		current_recipes = recipes.duplicate()
		$ProgressBar.visible = false
		Globals.clear_content_display.emit()

func check_recipe():
	for ingredient in current_recipes[0].ingredients:
		if ingredients.find(ingredient) == -1:
			return
	running = true
	$ProgressBar.visible = true

func activate(player: Player) -> bool:
	if not can_activate(player):
		return false
	var success := false
	var temp_recipes := current_recipes.duplicate()
	for recipe in temp_recipes:
		if recipe.ingredients.find(player.item_name) > -1:
			success = true
		else:
			current_recipes.erase(recipe)
	if success:
		Globals.add_content_display.emit(player.item_name)
		ingredients.push_back(player.item_name)
		player.item_name = ""
		player.item_icon.visible = false
		check_recipe()
	return success

func can_activate(player: Player) -> bool:
	if player.item_name != "":
		if ingredients.find(player.item_name) > -1:
			return false
		for recipe in current_recipes:
			if recipe.ingredients.find(player.item_name) > -1:
				Globals.set_prompt_display.emit("Press [Space] to add " + player.item_name + " to mixer.")
				return true
		return false
	else:
		return false

func on_area_2d_body_entered(body: Node2D):
	if body is Player:
		for recipe in recipes:
			Globals._add_recipe_display.emit(recipe)
		for ingredient in ingredients:
			Globals.add_content_display.emit(ingredient)
		(body as Player).activatables.push_back(self)
		(body as Player).update_prompt()

func on_area_2d_body_exited(body: Node2D):
	if body is Player:
		Globals._clear_recipe_display.emit()
		Globals.clear_content_display.emit()
		(body as Player).activatables.erase(self)
		(body as Player).update_prompt()
