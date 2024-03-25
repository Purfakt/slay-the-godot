class_name PlayerHandler
extends Node

const HAND_DRAW_INTERVAL := 0.25
const HAND_DISCARD_INTERVAL := 0.1

@export var hand: Hand
var character_stats: CharacterStats

func _ready():
	Events.card_played.connect(_on_card_played)

func start_battle(char_stats: CharacterStats) -> void:
	character_stats = char_stats
	character_stats.draw_pile = character_stats.deck.duplicate(true)
	character_stats.draw_pile.shuffle()
	character_stats.discard_pile = CardPile.new()
	start_turn()

func start_turn() -> void:
	character_stats.block = 0
	character_stats.reset_mana()
	draw_cards(character_stats.cards_per_turn)

func end_turn() -> void:
	hand.disable_hand()
	discard_cards()

func draw_card() -> void:
	reshuffle_deck_from_discard()
	hand.add_card(character_stats.draw_pile.draw_card())
	reshuffle_deck_from_discard()

func draw_cards(amount: int) -> void:
	var tween := create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)
	
	tween.finished.connect(
		func(): Events.player_hand_drawn.emit()
	)

func discard_cards() -> void:
	var tween := create_tween()
	for card_ui in hand.get_children():
		tween.tween_callback(character_stats.discard_pile.add_card.bind(card_ui.card))
		tween.tween_callback(hand.discard_card.bind(card_ui))
		tween.tween_interval(HAND_DISCARD_INTERVAL)
	
	tween.finished.connect(
		func(): Events.player_hand_discarded.emit()
	)

func reshuffle_deck_from_discard() -> void:
	if not character_stats.draw_pile.is_empty():
		return
	
	while not character_stats.discard_pile.is_empty():
		character_stats.draw_pile.add_card(character_stats.discard_pile.draw_card())
	
	character_stats.draw_pile.shuffle()

func _on_card_played(card: Card) -> void:
	character_stats.discard_pile.add_card(card)
