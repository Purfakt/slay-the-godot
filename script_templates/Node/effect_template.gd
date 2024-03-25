# meta-name: Effect
# meta-description: Create an effect which can be applied to a target
class_name MyEffect
extends Effect

var member_var 

func execute(targets: Array[Node]) -> void:
	print("Effect executed")
