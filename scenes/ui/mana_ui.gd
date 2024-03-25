class_name ManaUI
extends Panel

@export var char_stats: CharacterStats : set = _set_char_stats

@onready var mana_label: Label = $ManaLabel

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	
	if not char_stats.stats_changed.is_connected(_on_stat_changed):
		char_stats.stats_changed.connect(_on_stat_changed)
	
	if not is_node_ready():
		await ready
	
	_on_stat_changed()

func _on_stat_changed():
	mana_label.text = "%s/%s" % [char_stats.mana, char_stats.max_mana]
