class_name Recipe extends Resource

var product: String
var ingredients: Array[String]
	
func _init(_product: String, _ingredients: Array[String]):
	self.product = _product
	self.ingredients = _ingredients
