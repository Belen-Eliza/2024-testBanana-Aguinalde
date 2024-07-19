Class {
	#name : #SpaceshipTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #accessing }
SpaceshipTest >> createBoardOf: length distance: aDistance withEffects: someEffects wormholeBeginsAt: startPoint andEndsAt: endPoint [

	| squares |
	squares := OrderedCollection new.
	1 to: length  do: [ :i |
	squares add: (Square with: (NullEffect isIn: i)) ].

	someEffects do: [ :effect |
		squares at: effect squareNumber put: (Square with: effect) ].
	^ Board
		  with: squares
		  length: aDistance
		  wormholeBeginsAt: startPoint
		  andEndsAt: endPoint
]

{ #category : #asserting }
SpaceshipTest >> should: anErrorBlock raise: anError withMessage: errorMessage [

self 
	should: anErrorBlock 
	raise: anError 
	withExceptionDo: [ :error |
										self assert: error messageText  equals: errorMessage  ].
]

{ #category : #tests }
SpaceshipTest >> test026SpaceshipCreatedWithAName [
	
	| aSpaceship |
	aSpaceship := Spaceship randomCardsLaunch:  'Millenium Falcon'.
	self assert: aSpaceship getName equals: 'Millenium Falcon'	
]

{ #category : #tests }
SpaceshipTest >> test027SpaceshipCreatedWithAnotherName [

	| aSpaceship |
	aSpaceship := Spaceship randomCardsLaunch:  'Death Star'.
	self assert: aSpaceship getName equals: 'Death Star'	
]

{ #category : #tests }
SpaceshipTest >> test112SpaceshipCanBeCreatedWithTwoRandomCards [

	|  aSpaceship |
	aSpaceship := Spaceship randomCardsLaunch:  'One'.
	aSpaceship keepARecordWith: (SpaceshipLog for: aSpaceship  with: aSpaceship deck trackingPositionWith: (PositionTracker beginIn: nil)).
	
	self assert: (aSpaceship  cards size) equals:2 .
]

{ #category : #tests }
SpaceshipTest >> test113SpaceshipDataIsCreatedWithRandomValidCards [

	|  aSpaceship cardTypes |
	aSpaceship := Spaceship randomCardsLaunch:  'One'.
	aSpaceship keepARecordWith: (SpaceshipLog for: aSpaceship  with: aSpaceship deck trackingPositionWith: (PositionTracker beginIn: nil)).
	cardTypes := OrderedCollection
		             with: AccelerationCard
		             with: SpeedCard
		             with: MercenaryCard
		             with: RedoCard
		             with: RepeatCard.
	
	self assert: (aSpaceship cards allSatisfy: [:card | cardTypes includes: (card class) ]) .
]

{ #category : #tests }
SpaceshipTest >> test120SpaceshipsShieldsCannotBeLessThanZero [

	| aSpaceship aSpaceshipLog |
	aSpaceship := Spaceship randomCardsLaunch: 'Death Star'.
	aSpaceshipLog := SpaceshipLog
		                 for: aSpaceship
		                 with: aSpaceship deck
		                 trackingPositionWith:
			                 (PositionTracker beginIn: (self
					                   createBoardOf: 5
					                   distance: 5
					                   withEffects: {  }
					                   wormholeBeginsAt: 1
					                   andEndsAt: 2)).
	aSpaceship keepARecordWith: aSpaceshipLog.
	6 timesRepeat: [ aSpaceshipLog decreaseShieldsByOne ].
	self assert: aSpaceship shields equals: 0
]

{ #category : #tests }
SpaceshipTest >> test144SpaceshipLogCanCalculateHash [

	| aSpaceship hash aSpaceshipLog |
	aSpaceship :=( Spaceship randomCardsLaunch:  'Death Star').
	aSpaceshipLog := SpaceshipLog for: aSpaceship  with: aSpaceship deck  trackingPositionWith: (PositionTracker beginIn: nil).
	aSpaceship keepARecordWith: aSpaceshipLog .
	hash := aSpaceshipLog  hash.
	self assert: hash >0
]

{ #category : #tests }
SpaceshipTest >> test158SpaceshipBeginsWithAStarterDeck [

	| aSpaceship  |
	aSpaceship :=Spaceship launch: 'A test' with: { MercenaryCard . AccelerationCard  }.

	aSpaceship keepARecordWith: (SpaceshipLog for: aSpaceship  with: (aSpaceship deck ) trackingPositionWith: (PositionTracker beginIn: nil)).
	self assert: aSpaceship  cards  equals: (OrderedCollection with: MercenaryCard with: AccelerationCard) 
]

{ #category : #tests }
SpaceshipTest >> test159SpaceshipLogCannotBeAssignedTwice [

	| aSpaceship |
	aSpaceship := Spaceship launch: 'A test' with: {
			              MercenaryCard.
			              AccelerationCard }.

	aSpaceship keepARecordWith: (SpaceshipLog
			 for: aSpaceship
			 with: aSpaceship deck
			 trackingPositionWith: (PositionTracker beginIn: nil)).
	self
		should: [
			aSpaceship keepARecordWith: (SpaceshipLog
					 for: aSpaceship
					 with: aSpaceship deck
					 trackingPositionWith: (PositionTracker beginIn: nil)) ]
		raise: Error
		withMessage:
		'Spaceship log cannot be changed in the middle of the game'
]
