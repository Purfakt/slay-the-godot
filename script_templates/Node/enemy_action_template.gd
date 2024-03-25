# meta-name: EnemyAction
# meta-description: Action performed during enemy's turn.
extends EnemyAction

@export var optional_sound: AudioStream

func perform_action() -> void:
	if not enemy or not target:
		return
	
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	var start := enemy.global_position
	var end := target.global_position + Vector2.RIGHT * 32
	
	SfxPlayer.play(sound)
	
	Events.enemy_action_completed.emit(enemy)
