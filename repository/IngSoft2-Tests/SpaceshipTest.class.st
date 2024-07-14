Class {
	#name : #SpaceshipTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
SpaceshipTest >> test026SpaceshipCreatedWithAName [
	
	| aSpaceship |
	aSpaceship := Spaceship launch: 'Millenium Falcon'.
	self assert: aSpaceship getName equals: 'Millenium Falcon'	
]

{ #category : #tests }
SpaceshipTest >> test027SpaceshipCreatedWithAnotherName [

	| aSpaceship |
	aSpaceship := Spaceship launch: 'Death Star'.
	self assert: aSpaceship getName equals: 'Death Star'	
]

{ #category : #tests }
SpaceshipTest >> test112SpaceshipCanBeCreatedWithTwoRandomCards [

	|  aSpaceship |
	aSpaceship := Spaceship randomCardsLaunch:  'One'.
	aSpaceship keepARecordWith: (SpaceshipLog for: aSpaceship  with: aSpaceship starterDeck trackingPositionWith: (PositionTracker beginIn: nil)).
	
	self assert: (aSpaceship  cards size) equals:2 .
]

{ #category : #tests }
SpaceshipTest >> test113SpaceshipDataIsCreatedWithRandomValidCards [

	|  aSpaceship cardTypes |
	aSpaceship := Spaceship randomCardsLaunch:  'One'.
	aSpaceship keepARecordWith: (SpaceshipLog for: aSpaceship  with: aSpaceship starterDeck trackingPositionWith: (PositionTracker beginIn: nil)).
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
	aSpaceship :=( Spaceship randomCardsLaunch:  'Death Star').
	aSpaceshipLog := SpaceshipLog for: aSpaceship  with: aSpaceship starterDeck  trackingPositionWith: (PositionTracker beginIn: nil).
	aSpaceship keepARecordWith: aSpaceshipLog .
	6 timesRepeat: [ aSpaceshipLog  decreaseShieldsByOne ].
	self assert: aSpaceship shields  equals: 0
]

{ #category : #tests }
SpaceshipTest >> test144SpaceshipLogCanCalculateHash [

	| aSpaceship hash aSpaceshipLog |
	aSpaceship :=( Spaceship randomCardsLaunch:  'Death Star').
	aSpaceshipLog := SpaceshipLog for: aSpaceship  with: aSpaceship starterDeck  trackingPositionWith: (PositionTracker beginIn: nil).
	aSpaceship keepARecordWith: aSpaceshipLog .
	hash := aSpaceshipLog  hash.
	self assert: hash class  equals: SmallInteger 
]

{ #category : #tests }
SpaceshipTest >> test158SpaceshipBeginsWithAStarterDeck [

	| aSpaceship  |
	aSpaceship :=Spaceship launch: 'A test' with: { MercenaryCard . AccelerationCard  }.

	aSpaceship keepARecordWith: (SpaceshipLog for: aSpaceship  with: (aSpaceship starterDeck ) trackingPositionWith: (PositionTracker beginIn: nil)).
	self assert: aSpaceship  cards  equals: (OrderedCollection with: MercenaryCard with: AccelerationCard) 
]
