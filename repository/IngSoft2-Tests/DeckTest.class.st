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
	
	self assert: aDeck cards equals: { aCard . anotherCard }
]

{ #category : #tests }
DeckTest >> test152 [

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
