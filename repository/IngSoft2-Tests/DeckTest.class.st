Class {
	#name : #DeckTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
DeckTest >> test151DeckIsCreatedWithCards [

	| aDeck aCard anotherCard |
	aCard := MercenaryCard.
	anotherCard := SpeedCard .
	aDeck := Deck createWith: { aCard . anotherCard  }.

	self assert: aDeck cards equals: (OrderedCollection with: aCard  with: anotherCard )
]

{ #category : #tests }
DeckTest >> test152DeckIsCreatedWithRandomCards [

	| aDeck cardTypes |
	
	aDeck := Deck createWithRandomCards.

	cardTypes := OrderedCollection
		             with: AccelerationCard
		             with: SpeedCard
		             with: MercenaryCard
		             with: RedoCard
		             with: RepeatCard.
	
	self assert: (aDeck cards allSatisfy: [:card | cardTypes includes: (card class) ]) .

]

{ #category : #tests }
DeckTest >> test153CardsCanBeRemovedFromDeck [

	| aDeck aCard anotherCard |
	aCard := MercenaryCard.
	anotherCard := SpeedCard .
	aDeck := Deck createWith: { aCard . anotherCard  }.
	aDeck remove: aCard .

	self assert: aDeck cards equals: (OrderedCollection  with: anotherCard )
]

{ #category : #tests }
DeckTest >> test154ARandomCardIsAddedToDeck [

	| aDeck |
	
	aDeck := Deck createWithRandomCards .
	aDeck addRandomCard  .

	self assert: aDeck cards size equals: 3
]

{ #category : #tests }
DeckTest >> test155ARandomValidCardIsAddedToDeck [

	| aDeck cardTypes |
	
	aDeck := Deck createWithRandomCards .
	aDeck addRandomCard  .

	cardTypes := OrderedCollection
		             with: AccelerationCard
		             with: SpeedCard
		             with: MercenaryCard
		             with: RedoCard
		             with: RepeatCard.
	
	self assert: (aDeck cards allSatisfy: [:card | cardTypes includes: (card class) ]) .

]
