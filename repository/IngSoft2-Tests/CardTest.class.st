Class {
	#name : #CardTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #'set up' }
CardTest >> createBoardOf: length distance: aDistance withEffects: someEffects wormholeBeginsAt: startPoint andEndsAt: endPoint [

	| squares |
	squares := OrderedCollection new.
	1 to: length  do: [ :i |
	squares add: (Square with: (NullEffect isIn: i)) ].
	someEffects ifNotNil: [someEffects do: [ :effect |
		squares at: effect squareNumber  put: (Square with: effect) ]. ]. 
	^ Board
		  with: squares
		  length: aDistance
		  wormholeBeginsAt: startPoint
		  andEndsAt: endPoint
]

{ #category : #asserting }
CardTest >> should: anErrorBlock raise: anError withMessage: errorMessage [ 

	

self 
	should: anErrorBlock 
	raise: anError 
	withExceptionDo: [ :error |
										self assert: error messageText  equals: errorMessage  ]

]

{ #category : #tests }
CardTest >> test083WhenASpaceshipPlaysASpeedCardThenDiceThrowIncreasesByOne [

	| aGame aSpaceship aBoard aDie aCard |	
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie of: 3.
	aSpaceship := Spaceship launch: '' with: {SpeedCard . SpeedCard }.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := SpeedCard new.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	aGame playTurn.
	self assert: ( aSpaceship position ) equals: 5
]

{ #category : #tests }
CardTest >> test084SpeedCardOnlyIncreasesDiceThrowOfTheSpaceshipThatPlaysIt [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship |
	aSpaceship := Spaceship launch: 'One' with: {SpeedCard . SpeedCard }.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	yetAnotherSpaceship := Spaceship randomCardsLaunch:  'Three'.
	
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 2).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship . yetAnotherSpaceship } 
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := SpeedCard new.
	aGame play: aCard from: aSpaceship targeting: anotherSpaceship.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	self assert: (( aSpaceship position ) = 4 and: (( anotherSpaceship position ) = 5 and: ((yetAnotherSpaceship position ) = 3) )  )
	
]

{ #category : #tests }
CardTest >> test085WhenASpaceshipPlaysAnAccelerationCardThenDiceThrowIncreasesByOne [

	| aGame aSpaceship aBoard aDie aCard |
	aSpaceship := Spaceship launch: 'One' with: (OrderedCollection with: SpeedCard  with: AccelerationCard ) .
	
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie of: 3.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := AccelerationCard new.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	aGame playTurn.
	self assert: ( aSpaceship position ) equals: 5
]

{ #category : #tests }
CardTest >> test086AccelerationCardIncreasesDiceThrowForAllSpaceships [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship |
	aSpaceship := Spaceship launch: 'One' with: {SpeedCard . AccelerationCard }.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	yetAnotherSpaceship := Spaceship randomCardsLaunch:  'Three'.
	
		aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 4 with: 2).
	
		
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship . yetAnotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := AccelerationCard new.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	self assert: (( aSpaceship position ) = 5 and:
			 (( anotherSpaceship position ) = 6 and:
				  (yetAnotherSpaceship position ) = 4))
]

{ #category : #tests }
CardTest >> test087MercenaryCardCanRecruitOneMercenaryThatHelpsInBattles [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship |
	aSpaceship := Spaceship launch: 'One' with: {MercenaryCard . AccelerationCard }.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	yetAnotherSpaceship := Spaceship randomCardsLaunch:  'Three'.
	
		aBoard := self
		          createBoardOf: 8
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 7
		          andEndsAt: 8.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 4).
	
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship . yetAnotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.
	aGame
		play: aCard
		from: aSpaceship
		targeting: yetAnotherSpaceship.
	aGame playTurn.
	aGame playTurn.
	self assert: (( aSpaceship position ) = 4 and: ( anotherSpaceship position ) = 1)
]

{ #category : #tests }
CardTest >> test088IfSpaceshipAndOneMercenaryLoseTheBattleBothLoseShields [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship  |
	aSpaceship := Spaceship launch: 'One' with: {MercenaryCard . AccelerationCard }.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	yetAnotherSpaceship := Spaceship randomCardsLaunch:  'Three'.
		aBoard := self
		          createBoardOf: 8
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 7
		          andEndsAt: 8.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 8).
	aGame := Game
		         playedBy:  {aSpaceship . anotherSpaceship . yetAnotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.
	aGame
		play: aCard
		from: aSpaceship
		targeting: yetAnotherSpaceship.
	aGame playTurn.
	aGame playTurn.
	self assert: ((aSpaceship shields ) = 2 and:
			 (yetAnotherSpaceship shields ) = 2)
]

{ #category : #tests }
CardTest >> test089ASpaceshipCanRecruitMultipleMercenariesThetHelpInBattle [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship fourthSpaceship |
	aSpaceship := Spaceship launch: 'One' with: {MercenaryCard . MercenaryCard  }.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	yetAnotherSpaceship := Spaceship randomCardsLaunch:  'Three'.
	fourthSpaceship := Spaceship randomCardsLaunch:  'Four'.
		aBoard := self
		          createBoardOf: 8
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 7
		          andEndsAt: 8.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 8).
	
	aGame := Game
		         playedBy:  {aSpaceship . anotherSpaceship . yetAnotherSpaceship . fourthSpaceship } 
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.
	aGame
		play: aCard
		from: aSpaceship
		targeting: yetAnotherSpaceship.
	aGame play: aCard from: aSpaceship targeting: fourthSpaceship.
	aGame playTurn.
	aGame playTurn.
	self assert: ((aSpaceship position ) = 4 and:
			 (anotherSpaceship position ) = 1)
]

{ #category : #tests }
CardTest >> test090IfSpaceshipAndMultipleMercenariesLoseTheBattleTheyAllLoseShields [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship fourthSpaceship anotherCard |
	aSpaceship := Spaceship launch: 'One' with: {MercenaryCard . MercenaryCard  }.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	yetAnotherSpaceship := Spaceship randomCardsLaunch:  'Three'.
	fourthSpaceship := Spaceship randomCardsLaunch:  'Four'.
	
			aBoard := self
		          createBoardOf: 8
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 7
		          andEndsAt: 8.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 12 with: 3).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship . yetAnotherSpaceship . fourthSpaceship } 
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.
	anotherCard := MercenaryCard new.
	aGame
		play: aCard
		from: aSpaceship
		targeting: yetAnotherSpaceship.
	aGame
		play: anotherCard
		from: aSpaceship
		targeting: fourthSpaceship.
	aGame playTurn.
	aGame playTurn.

	self assert: ((aSpaceship shields ) = 2 and:
			 ((yetAnotherSpaceship shields ) = 2 and:
				  (fourthSpaceship shields ) = 2))
]

{ #category : #tests }
CardTest >> test091MultipleSpeedCardsCanBeActiveAtTheSameTime [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship anotherCard |
	aSpaceship := Spaceship launch: 'One' with: {SpeedCard . SpeedCard }.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	yetAnotherSpaceship := Spaceship randomCardsLaunch:  'Three'.
		aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 2).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship . yetAnotherSpaceship } 
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := SpeedCard new.
	anotherCard := SpeedCard new.
	aGame play: aCard from: aSpaceship targeting: anotherSpaceship.
	aGame
		play: anotherCard
		from: aSpaceship
		targeting: anotherSpaceship.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	self assert: (( aSpaceship position ) = 7 and: (( anotherSpaceship position ) = 11 and: (( yetAnotherSpaceship position) = 3) )  )
	

]

{ #category : #tests }
CardTest >> test092MultipleAccelerationCardsCanBeActiveAtTheSameTime [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship anotherCard  |
	aSpaceship := Spaceship launch: 'One' with: {AccelerationCard . AccelerationCard }.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	yetAnotherSpaceship := Spaceship randomCardsLaunch:  'Three'.
	
		aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 4 with: 3 with: 2).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship . yetAnotherSpaceship } 
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := AccelerationCard new.
	anotherCard := AccelerationCard new.
	aGame play: aCard from: aSpaceship targeting: anotherSpaceship.
	aGame
		play: anotherCard
		from: aSpaceship
		targeting: anotherSpaceship.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	self assert: (( aSpaceship position ) = 7 and: (( anotherSpaceship position) = 6 and: ((yetAnotherSpaceship position) = 5) )  )

]

{ #category : #tests }
CardTest >> test093MultipleSpaceshipsCannotHaveTheSameMercenary [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship fourthSpaceship  anotherCard |
	aSpaceship := Spaceship launch: 'One' with: {MercenaryCard . MercenaryCard }.
	anotherSpaceship := Spaceship launch: 'Two' with: {MercenaryCard . MercenaryCard }.
	yetAnotherSpaceship := Spaceship randomCardsLaunch:  'Three'.
	fourthSpaceship := Spaceship randomCardsLaunch:  'Four'.
		aBoard := self
		          createBoardOf: 8
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 7
		          andEndsAt: 8.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 8).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship . yetAnotherSpaceship . fourthSpaceship } 
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.
	anotherCard := MercenaryCard new.
	aGame
		play: aCard
		from: aSpaceship
		targeting: yetAnotherSpaceship.
	aGame playTurn.
	self
		should: [
			aGame
				play: anotherCard
				from: anotherSpaceship
				targeting: yetAnotherSpaceship ]
		raise: Error
		withMessage: 'Selected spaceship is already a mercenary'
]

{ #category : #tests }
CardTest >> test094ASpaceshipDoesNotBattleWithItsMercenary [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard  |
	aSpaceship := Spaceship launch: 'One' with: {MercenaryCard . MercenaryCard }.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	
	aBoard := self
		          createBoardOf: 8
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 7
		          andEndsAt: 8.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.
	aGame play: aCard from: aSpaceship targeting: anotherSpaceship.
	aGame playTurn.
	aGame playTurn.
	self assert: (( aSpaceship position ) = 4 and:
			 (anotherSpaceship position ) = 4)
]

{ #category : #tests }
CardTest >> test095CancellationCardCanRemoveActiveMercenaryCards [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard anotherCard  |
	aSpaceship := Spaceship launch: 'One' with: {MercenaryCard . MercenaryCard }.
	anotherSpaceship := Spaceship launch: 'Two' with: {MercenaryCard . CancellationCard  }.
	
	aBoard := self
		          createBoardOf: 8
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 7
		          andEndsAt: 8.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 4).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.
	anotherCard := CancellationCard new.
	aGame play: aCard from: aSpaceship targeting: anotherSpaceship.
	aGame playTurn.
	aGame play: anotherCard from: anotherSpaceship targeting: aCard.
	aGame playTurn.
	self assert: ((aSpaceship position ) = 1 and:
			 (anotherSpaceship position ) = 4)
]

{ #category : #tests }
CardTest >> test096CancellationCardCanRemoveActiveSpeedCards [

	| aGame aSpaceship aBoard aDie aCard anotherCard  |
	aSpaceship := Spaceship launch: 'One' with: {SpeedCard . CancellationCard  }.
	
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie of: 3.

	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := SpeedCard new.
	anotherCard := CancellationCard new.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	aGame play: anotherCard from: aSpaceship targeting: aCard.
	aGame playTurn.
	self assert: (aSpaceship position ) equals: 4
]

{ #category : #tests }
CardTest >> test097CancellationCardCanNotBePlayedOnACardThatIsNotActive [

	| aGame aSpaceship aBoard aDie aCard anotherCard yetAnotherCard |
	aSpaceship := Spaceship launch: 'One' with: {SpeedCard . CancellationCard . CancellationCard   }.

	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie of: 3.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := SpeedCard new.
	anotherCard := CancellationCard new.
	yetAnotherCard:= CancellationCard new.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	aGame play: anotherCard from: aSpaceship targeting: aCard.

	self
		should: [
		aGame play: yetAnotherCard from: aSpaceship targeting: aCard ]
		raise: Error
		withMessage: 'Selected card is not active'
]

{ #category : #tests }
CardTest >> test098PermanentCardCannotBePlayedOutOfTurn [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard |
	aSpaceship := Spaceship launch: 'One'  with: {SpeedCard . CancellationCard  }.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.

		aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 2).
	
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := SpeedCard new.
	aGame playTurn.
	self
		should: [
		aGame play: aCard from: aSpaceship targeting: anotherSpaceship ]
		raise: Error
		withMessage: 'Card cannot be played out of turn'
]

{ #category : #tests }
CardTest >> test099InstantaneousCardCanBePlayedOutOfTurn [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard anotherCard |
	aSpaceship := Spaceship launch: 'One'  with: {MercenaryCard  . CancellationCard  }.
	anotherSpaceship := Spaceship launch: 'Two'  with: {SpeedCard . CancellationCard  }.
		aBoard := self
		          createBoardOf: 8
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 7
		          andEndsAt: 8.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 4).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.
	anotherCard := CancellationCard new.
	aGame play: aCard from: aSpaceship targeting: anotherSpaceship.
	aGame play: anotherCard from: anotherSpaceship targeting: aCard.
	aGame playTurn.
	self assert: (aSpaceship position ) equals: 4
]

{ #category : #tests }
CardTest >> test100CardsCannotBePlayedAfterGameIsOver [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard |
	aSpaceship := Spaceship launch: 'One'  with: {MercenaryCard  . CancellationCard  }.
	anotherSpaceship := Spaceship launch: 'Two'  with: {SpeedCard . CancellationCard  }.
		aBoard := self
		          createBoardOf: 8
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 7
		          andEndsAt: 8.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 3 with: 4).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.

	aGame end.
	self
		should: [
		aGame play: aCard from: aSpaceship targeting: anotherSpaceship ]
		raise: Error
		withMessage: 'Cards cannot be played after game is over'
]

{ #category : #tests }
CardTest >> test101RedoCardCanCopyLastSpeedCardPlayedAndApplyItToADifferentTarget [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard anotherCard |
	aSpaceship := Spaceship launch: 'One'  with: {SpeedCard   . CancellationCard  }.
	anotherSpaceship := Spaceship launch: 'Two'  with: {RedoCard  . CancellationCard  }.
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 13
		          andEndsAt: 14.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 4 with: 5 with: 3).
	aGame := Game
		         playedBy:  {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := SpeedCard new.
	anotherCard := RedoCard new.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	aGame playTurn.
	aGame
		play: anotherCard
		from: anotherSpaceship
		targeting: anotherSpaceship.
	aGame playTurn.
	self assert: ((aSpaceship position ) = 6 and:
			 ( anotherSpaceship position ) = 7)
]

{ #category : #tests }
CardTest >> test102RedoCardCanCopyAnotherRedoCard [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard anotherCard yetAnotherCard |
	aSpaceship := Spaceship launch: 'One'  with: {SpeedCard   . RedoCard }.
	anotherSpaceship := Spaceship launch: 'Two'  with: {RedoCard  . CancellationCard  }.
		aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 13
		          andEndsAt: 14.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 4 with: 5).
	aGame := Game
		         playedBy:  {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := SpeedCard new.
	anotherCard := RedoCard new.
	yetAnotherCard:= RedoCard new.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	aGame playTurn.
	aGame
		play: anotherCard
		from: anotherSpaceship
		targeting: anotherSpaceship.
	aGame playTurn.
	aGame
		play: yetAnotherCard
		from: aSpaceship 
		targeting: aSpaceship .
	aGame playTurn.
	self assert: ((aSpaceship position ) = 12 and:
			 (anotherSpaceship position ) = 7)
]

{ #category : #tests }
CardTest >> test103RedoCardCannotBePlayedFirst [

	| aGame aSpaceship aBoard aDie anotherSpaceship anotherCard |
	aSpaceship := Spaceship launch: 'One'  with: {SpeedCard   . CancellationCard  }.
	anotherSpaceship := Spaceship launch: 'Two'  with: {RedoCard  . CancellationCard  }.
	
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 13
		          andEndsAt: 14.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 4 with: 5).
	aGame := Game
		         playedBy:  {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	anotherCard := RedoCard new.
	aGame playTurn.

	self
		should: [
			aGame
				play: anotherCard
				from: anotherSpaceship
				targeting: anotherSpaceship ]
		raise: Error
		withMessage: 'There are no cards played to redo'
]

{ #category : #tests }
CardTest >> test104WhenRepeatCardIsPlayedAfterBlackholeEffectThenTargetSpaceshipGoesBackFourSquares [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard |
	aSpaceship := Spaceship launch: 'One'  with: {SpeedCard . CancellationCard  }.
	anotherSpaceship := Spaceship launch: 'Two'  with: {RepeatCard. CancellationCard  }.
	
	aBoard := self
		          createBoardOf: 10
		          distance: 5
		          withEffects:
		          (OrderedCollection with: (BlackholeEffect isIn: 4))
		          wormholeBeginsAt: 8
		          andEndsAt: 9.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 4 with: 3).
	aGame := Game
		         playedBy:  {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := RepeatCard new.
	aGame playTurn.
	aGame playTurn.
	aGame play: aCard from: anotherSpaceship targeting: aSpaceship.

	self assert: ( aSpaceship position ) equals: 1
]

{ #category : #tests }
CardTest >> test105WhenRepeatCardIsPlayedAfterWormholeEffectThenTargetSpaceshipGoesToTheOtherSide [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard |
	aSpaceship := Spaceship randomCardsLaunch:  'One' .
	anotherSpaceship := Spaceship launch: 'Two'  with: {RepeatCard . CancellationCard  }.

	aBoard := self
		          createBoardOf: 10
		          distance: 5
		          withEffects: OrderedCollection new
		          wormholeBeginsAt: 4
		          andEndsAt: 8.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 4).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := RepeatCard new.
	aGame playTurn.
	aGame
		play: aCard
		from: anotherSpaceship
		targeting: anotherSpaceship.

	self assert: (anotherSpaceship position ) equals: 8
]

{ #category : #tests }
CardTest >> test106WhenRepeatCardIsPlayedAfterHyperJumpThenTargetSpaceshipMovesSameAmountOfSquaresAsTheSpaceshipThatTriggeredIt [

	| aGame aSpaceship aBoard aDie aParsecDistance anotherSpaceship aCard anotherParsecDistance|
	aSpaceship := Spaceship randomCardsLaunch:  'One' .
	anotherSpaceship := Spaceship launch: 'Two'  with: {RepeatCard . CancellationCard  }.
	aParsecDistance := ParsecDistance of: 1.
	anotherParsecDistance := ParsecDistance of: 2.

	aBoard := self
		          createBoardOf: 20
		          distance: (ParsecDistance of: 5)
		          withEffects: (OrderedCollection with: (HyperJumpEffect
					            isIn: 6
					            movesDistance:
					            (OrderedCollection
						             with: aParsecDistance
						             with: anotherParsecDistance)))
		          wormholeBeginsAt: 1
		          andEndsAt: 2.


	aDie := LoadedDie of: 5.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aCard := RepeatCard new.
	aGame playTurn.
	aGame
		play: aCard
		from: anotherSpaceship
		targeting: anotherSpaceship.

	self assert: ( anotherSpaceship position ) equals: 5
]

{ #category : #tests }
CardTest >> test107WhenRepeatCardIsPlayedAfterMoonWalkThenSpaceshipsGoBackTwice [

	| aGame aSpaceship aBoard aDie anotherSpaceship yetAnotherSpaceship aCard  |
	aSpaceship := Spaceship launch: 'One' with: {RepeatCard . AccelerationCard }.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	yetAnotherSpaceship := Spaceship randomCardsLaunch:  'Three'.
	
	aBoard := self createBoardOf: 20 distance: 20 withEffects: (OrderedCollection with: (MoonWalkEffect isIn: 6  moves: 2) ) wormholeBeginsAt: 18 andEndsAt: 19.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 5).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship . yetAnotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aCard:= RepeatCard new.
	
	aGame playTurn.
	aGame playTurn.
	aGame play: aCard from: aSpaceship  targeting: aSpaceship.

	self assert: (((yetAnotherSpaceship position) = 1) and: (((aSpaceship position ) = 2) and: ((anotherSpaceship position ) = 4))   ) 
]

{ #category : #tests }
CardTest >> test108WhenRepeatCardIsPlayedAfterHyperSpaceJumpEffectThenTargetSpaceshipAdvancesFourSquaresAndLosesAShield [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard |
	aSpaceship := Spaceship launch: 'One' with: {RepeatCard . AccelerationCard }.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.

	aBoard := self
		          createBoardOf: 10
		          distance: 5
		          withEffects:
		          (OrderedCollection with: (HyperSpaceJumpEffect isIn: 4))
		          wormholeBeginsAt: 8
		          andEndsAt: 9.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 4 with: 3).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := RepeatCard new.
	aGame playTurn.
	aGame playTurn.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.

	self assert: (( aSpaceship position ) = 9 and:
			 (aSpaceship  shields ) = 2)
]

{ #category : #tests }
CardTest >> test109WhenRepeatCardIsPlayedAfterAtomicBombEffectThenAllShieldsGetDecreasedTwice [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship |
	aSpaceship := Spaceship launch: 'One' with: {RepeatCard . AccelerationCard }.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	yetAnotherSpaceship := Spaceship randomCardsLaunch:  'Three'.

	aBoard := self
		          createBoardOf: 10
		          distance: 5
		          withEffects:
		          (OrderedCollection with: (AtomicBombEffect isIn: 4))
		          wormholeBeginsAt: 8
		          andEndsAt: 9.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 5 with: 3).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship . yetAnotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := RepeatCard new.
	aGame playTurn.
	aGame playTurn.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	self assert: (aSpaceship shields = 1 and:
			 (anotherSpaceship shields = 1 and:
				  anotherSpaceship shields = 1))
]

{ #category : #tests }
CardTest >> test110RepeatCardDoesNothingIfLastSquareHadNoEffect [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship |
	aSpaceship := Spaceship launch: 'One' with: {RepeatCard . AccelerationCard }.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	yetAnotherSpaceship := Spaceship randomCardsLaunch:  'Three'.
	aBoard := self
		          createBoardOf: 10
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 9
		          andEndsAt: 10.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 4 with: 3).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship . yetAnotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := RepeatCard new.
	aGame playTurn.
	aGame playTurn.
	aGame play: aCard from: aSpaceship targeting: anotherSpaceship  .
	
	self assert: ((anotherSpaceship  shields  = 3) and: ( anotherSpaceship position = 4))
]

{ #category : #tests }
CardTest >> test111IfNoSpaceshipHasPlayedYetRepeatCardHasNoEffect [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship |
	aSpaceship := Spaceship launch: 'One' with: {RepeatCard . AccelerationCard }.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	yetAnotherSpaceship := Spaceship randomCardsLaunch:  'Three'.
	aBoard := self
		          createBoardOf: 10
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 9
		          andEndsAt: 10.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 4 with: 3).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship . yetAnotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := RepeatCard new.
	aGame play: aCard from: aSpaceship targeting: anotherSpaceship  .
	
	self assert: (((anotherSpaceship  shields )  = 3) and: (anotherSpaceship position  = 1)) .
]

{ #category : #tests }
CardTest >> test114ASpaceshipCannotPlayACardThatIsNotInItsHand [

	| aGame aSpaceship aBoard aDie aCard |
	aSpaceship := Spaceship launch: 'One' with: {AccelerationCard . AccelerationCard }.
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie of: 3.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := SpeedCard new.
	
	self should: [ aGame play: aCard from: aSpaceship targeting: aSpaceship ] raise: Error withMessage: 'A Spaceship cannot play a card that is not in its hand'
]

{ #category : #tests }
CardTest >> test115IfASpaceshipPlaysACardItIsRemovedFromItsHand [

	| aGame aSpaceship aBoard aDie aCard anotherCard |
	aSpaceship := Spaceship launch: 'One' with: {SpeedCard . AccelerationCard }.
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 14
		          andEndsAt: 15.

	aDie := LoadedDie of: 3.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := SpeedCard new.
	anotherCard:= SpeedCard new.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	
	self should: [ aGame play: anotherCard from: aSpaceship targeting: aSpaceship ] raise: Error withMessage: 'A Spaceship cannot play a card that is not in its hand'
]

{ #category : #tests }
CardTest >> test116MysteryCardEffectAddsACardToASpaceshipThatLandsInIt [

	| aGame aSpaceship aBoard aDie mysteryCardEffect |
	aSpaceship := Spaceship randomCardsLaunch: ''.
	mysteryCardEffect := (MysteryCardEffect isIn: 4).
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (OrderedCollection with: mysteryCardEffect)
		          wormholeBeginsAt: 13
		          andEndsAt: 14.

	aDie := LoadedDie of: 3.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aGame playTurn .
	
	self assert: (aSpaceship cards size) equals: 3
]

{ #category : #tests }
CardTest >> test117MysteryCardEffectAddsValidCardTypesToSpaceships [

	| aGame aSpaceship aBoard aDie mysteryCardEffect cardTypes |
	aSpaceship := Spaceship randomCardsLaunch: ''.
	
	mysteryCardEffect := (MysteryCardEffect isIn: 4).
	
	aBoard := self
		          createBoardOf: 20
		          distance: (ParsecDistance of: 1)
		          withEffects: (OrderedCollection with: mysteryCardEffect)
		          wormholeBeginsAt: 13
		          andEndsAt: 14.
	aDie := LoadedDie of: 3.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	cardTypes := OrderedCollection
		             with: AccelerationCard
		             with: SpeedCard
		             with: MercenaryCard
		             with: RedoCard
		             with: RepeatCard.
	aGame playTurn.


	self assert: (aSpaceship  cards allSatisfy: [ :card |
			 cardTypes includes: card class ])
]

{ #category : #tests }
CardTest >> test118MercenarySpaceshipDoesNotRecieveHelpFromItsAlly [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard yetAnotherSpaceship  |
	aSpaceship := Spaceship launch: 'One' with: { MercenaryCard . AccelerationCard  } .
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	yetAnotherSpaceship := Spaceship randomCardsLaunch:  'Three'.
	aBoard := self
		          createBoardOf: 8
		          distance: (ParsecDistance of: 1)
		          withEffects: (nil)
		          wormholeBeginsAt: 6
		          andEndsAt: 7.

	aDie := LoadedDie arrayOf:(OrderedCollection with: 1 with: 4 with: 4).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship . yetAnotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.
	aGame
		play: aCard
		from: aSpaceship
		targeting: yetAnotherSpaceship.
	aGame playTurn.
	aGame playTurn.
	self assert: (yetAnotherSpaceship position ) equals: 1
]

{ #category : #tests }
CardTest >> test119WhenRepeatCardIsPlayedAfterMysteryCardEffectThenTargetSpaceshipGainsACard [

	| aGame aSpaceship aBoard aDie anotherSpaceship aCard mysteryCardEffect |
	aSpaceship := Spaceship randomCardsLaunch:  'One'.
	anotherSpaceship := Spaceship launch: 'Two' with: {RepeatCard . AccelerationCard }.
	
	mysteryCardEffect := ( MysteryCardEffect isIn: 4).
	
	aBoard := self
		          createBoardOf: 10
		          distance: (ParsecDistance of: 1)
		          withEffects: (OrderedCollection with: mysteryCardEffect)
		          wormholeBeginsAt: 8
		          andEndsAt: 9.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 4 with: 3).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := RepeatCard new.
	aGame playTurn.
	aGame playTurn.
	aGame play: aCard from: anotherSpaceship targeting: aSpaceship .
	
	self assert: (aSpaceship cards size) equals: 3.
]

{ #category : #tests }
CardTest >> test125SpaceshipCannotAppointItselfAsItsMercenary [

	| aGame aSpaceship aBoard aDie aCard |
	aSpaceship := Spaceship launch: 'One' with: {MercenaryCard }.

	aBoard := self
		          createBoardOf: 10
		          distance: 1
		          withEffects: OrderedCollection new
		          wormholeBeginsAt: 8
		          andEndsAt: 9.
 
	aDie := LoadedDie of: 3.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard new.

	self
		should: [
		aGame play: aCard from: aSpaceship targeting: aSpaceship ]
		raise: Error
		withMessage: 'A spaceship cannot be its own mercenary'
]

{ #category : #tests }
CardTest >> test126WhenRedoCardCopiesMercenaryCardThenAlliedSpaceshipsDoNotBattle [

	| aGame aSpaceship anotherSpaceship yetAnotherSpaceship aBoard aDie aCard anotherCard |
	aSpaceship := Spaceship launch: 'One' with: {MercenaryCard }.
	anotherSpaceship := Spaceship launch: 'Two' with: {RedoCard   }.
	yetAnotherSpaceship := Spaceship randomCardsLaunch:  'Three'.
	aBoard := self createBoardOf: 16 distance: 5 withEffects: (OrderedCollection new) wormholeBeginsAt: 13 andEndsAt: 14.

	aDie := LoadedDie arrayOf:
		        (OrderedCollection with: 3 with: 4 with: 4).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship . yetAnotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := MercenaryCard  new.
	anotherCard := RedoCard new.
	aGame play: aCard from: aSpaceship targeting: anotherSpaceship .
	aGame playTurn.
	aGame
		play: anotherCard
		from: anotherSpaceship
		targeting: yetAnotherSpaceship.
	aGame playTurn.
	aGame playTurn .
	self assert: ((anotherSpaceship position) = 5 and:
			 ( yetAnotherSpaceship position ) = 5)
]

{ #category : #tests }
CardTest >> test127WhenRedoCardCopiesAccelerationCardThenAllSpaceshipsIncreaseTheirThrowByTwo [

	| aGame aSpaceship anotherSpaceship yetAnotherSpaceship aBoard aDie aCard anotherCard |
	aSpaceship := Spaceship launch: 'One' with: {AccelerationCard  }.
	anotherSpaceship := Spaceship launch: 'Two' with: {RedoCard   }.
	yetAnotherSpaceship := Spaceship randomCardsLaunch:  'Three'.
	aBoard := self createBoardOf: 16 distance: 5 withEffects: (OrderedCollection new) wormholeBeginsAt: 13 andEndsAt: 14.

	aDie := LoadedDie arrayOf:
		        (OrderedCollection with: 1 with: 4 with: 6).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship . yetAnotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := AccelerationCard   new.
	anotherCard := RedoCard new.
	aGame play: aCard from: aSpaceship targeting: anotherSpaceship .
	aGame playTurn.
	aGame
		play: anotherCard
		from: anotherSpaceship
		targeting: yetAnotherSpaceship.
	3 timesRepeat: 	[aGame playTurn].

	self assert: (((aSpaceship position ) = 6) and: (((anotherSpaceship position )  = 7) and: (( yetAnotherSpaceship position )  = 9) ) )
]

{ #category : #tests }
CardTest >> test128WhenRedoCardCopiesCancellationCardThenThrowIncreaseIsCancelled [

	| aGame aSpaceship anotherSpaceship aBoard aDie aSpeedCard anotherSpeedCard aRedoCard aCancellationCard |
	aSpaceship := Spaceship launch: 'One' with: {SpeedCard . SpeedCard }.
	anotherSpaceship := Spaceship launch: 'Two' with: {RedoCard  . CancellationCard  }.
	aBoard := self
		          createBoardOf: 16
		          distance: 5
		          withEffects: OrderedCollection new
		          wormholeBeginsAt: 13
		          andEndsAt: 14.

	aDie := LoadedDie of: 3.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aSpeedCard  := SpeedCard new.
	anotherSpeedCard  := SpeedCard  new.
	aCancellationCard  := CancellationCard new.
	aRedoCard  := RedoCard new.
	
	aGame play: aSpeedCard   from: aSpaceship  targeting: aSpaceship .
	aGame play: anotherSpeedCard  from: aSpaceship  targeting: aSpaceship .
	aGame play: aCancellationCard  from: anotherSpaceship  targeting: aSpeedCard .
	aGame play: aRedoCard  from: anotherSpaceship  targeting: anotherSpeedCard .
	aGame playTurn .
	
	self assert: (aSpaceship position ) equals: 4
	
]

{ #category : #tests }
CardTest >> test129WhenRedoCardCopiesRepeatCardThenEffectIsAppliedAgain [

	| aGame aSpaceship anotherSpaceship aBoard aDie aRepeatCard  aRedoCard |
	aSpaceship := Spaceship launch: 'One' with: {RedoCard  . SpeedCard }.
	anotherSpaceship := Spaceship launch: 'Two' with: {RepeatCard   . CancellationCard  }.

	aBoard := self
		          createBoardOf: 16
		          distance: 5
		          withEffects: (OrderedCollection with: (HyperSpaceJumpEffect isIn: 4))
		          wormholeBeginsAt: 13
		          andEndsAt: 14.

	aDie := LoadedDie of: 3.
	aGame := Game
		         playedBy:  {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aRepeatCard := RepeatCard new.
	aRedoCard  := RedoCard new.
	
	
	aGame playTurn .
	aGame play: aRepeatCard  from: anotherSpaceship  targeting: anotherSpaceship .
	aGame play: aRedoCard  from: aSpaceship  targeting: aSpaceship .
	
	self assert: (aSpaceship position ) equals: 12
	
]

{ #category : #tests }
CardTest >> test130CancellationCardCanRemoveActiveAccelerationCards [

	| aGame aSpaceship aBoard aDie  aCard anotherCard  anotherSpaceship |
	aSpaceship := Spaceship launch: 'One' with: {AccelerationCard   . CancellationCard  }.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	
	aBoard := self createBoardOf: 16 distance: 5 withEffects: {  } wormholeBeginsAt: 13 andEndsAt: 14.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 4).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := AccelerationCard  new.
	anotherCard := CancellationCard new.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	aGame play: anotherCard from: aSpaceship targeting: aCard.
	aGame playTurn.
	aGame playTurn.
	self assert: (((aSpaceship position ) = 4) and: ((anotherSpaceship position ) = 5) )
]

{ #category : #tests }
CardTest >> test145ActiveMovementCardsDoNotIncrementDiceThrowForBattles [

	| aGame aSpaceship aBoard aDie  aCard anotherCard anotherSpaceship |
	aSpaceship := Spaceship launch: 'One' with: {AccelerationCard . SpeedCard   }.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	
	aBoard := self createBoardOf: 16 distance: 5 withEffects: {  } wormholeBeginsAt: 13 andEndsAt: 14.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 5 with: 4 with: 1 with: 1).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := AccelerationCard  new.
	anotherCard := SpeedCard new.
	aGame play: aCard from: aSpaceship targeting: aSpaceship.
	aGame play: anotherCard from: aSpaceship targeting: anotherSpaceship .
	aGame playTurn.
	aGame playTurn.
	self assert: (((aSpaceship position ) = 7) and: (( anotherSpaceship position ) = 1) )
]

{ #category : #tests }
CardTest >> test146CancellationCardCanRemoveActiveAccelerationCardsPlayedWithRedo [

	| aGame aSpaceship aBoard aDie  anAccelerationCard  aRedoCardCard aCancellationCard anotherSpaceship |
	aSpaceship := Spaceship launch: 'One' with: {AccelerationCard   . CancellationCard  }.
	anotherSpaceship := Spaceship launch:  'Two' with: {AccelerationCard . RedoCard }.
	
	aBoard := self createBoardOf: 16 distance: 5 withEffects: {  } wormholeBeginsAt: 13 andEndsAt: 14.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 4).
	aGame := Game
		         playedBy: { aSpaceship . anotherSpaceship  }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	anAccelerationCard := AccelerationCard  new.
	aCancellationCard  := CancellationCard new.
	aRedoCardCard := RedoCard new.
	aGame play: anAccelerationCard from: aSpaceship targeting: aSpaceship.
	
	aGame playTurn.
	
	aGame play: aRedoCardCard from: anotherSpaceship  targeting: anotherSpaceship.
	aGame play: aCancellationCard  from: aSpaceship  targeting: anAccelerationCard .

	aGame playTurn.
	self assert: ((( aSpaceship position ) = 5) and: (( anotherSpaceship position ) = 6) )
]

{ #category : #tests }
CardTest >> test147CancellationCardCanRemoveActiveSpeedCardsPlayedWithRedo [

	| aGame aSpaceship aBoard aDie  aSpeedCard anotherSpeedCard aRedoCard aCancellationCard anotherSpaceship |
	aSpaceship := Spaceship launch: 'One' with: {SpeedCard . CancellationCard  }.
	anotherSpaceship := Spaceship launch:  'Two' with: {AccelerationCard . RedoCard }.
	
	aBoard := self createBoardOf: 16 distance: 5 withEffects: {  } wormholeBeginsAt: 13 andEndsAt: 14.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 5).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aSpeedCard  := SpeedCard new.
	aCancellationCard  := CancellationCard new.
	aRedoCard := RedoCard new.
	aGame play: aSpeedCard from: aSpaceship targeting: aSpaceship.
	
	aGame playTurn.
	
	anotherSpeedCard := aGame play: aRedoCard from: anotherSpaceship  targeting: anotherSpaceship .
	aGame play: aCancellationCard  from: aSpaceship  targeting: anotherSpeedCard.

	aGame playTurn.
	self assert: (((aSpaceship position ) = 5) and: ((anotherSpaceship position ) = 6) )
]

{ #category : #tests }
CardTest >> test148CancellationCardOnlyRemovesSpecifiedCard [

	| aGame aSpaceship aBoard aDie  aSpeedCard  anotherSpeedCard aCancellationCard anotherSpaceship |
	aSpaceship := Spaceship launch: 'One' with: {SpeedCard . CancellationCard }.
	anotherSpaceship := Spaceship launch: 'Two' with: {SpeedCard . RedoCard }.
	
	aBoard := self createBoardOf: 16 distance: 5 withEffects: {  } wormholeBeginsAt: 13 andEndsAt: 14.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 5).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aSpeedCard  := SpeedCard new.
	aCancellationCard  := CancellationCard new.
	anotherSpeedCard  := SpeedCard  new.
	aGame play: aSpeedCard from: aSpaceship targeting: aSpaceship.
	
	aGame playTurn.
	
	aGame play: anotherSpeedCard from: anotherSpaceship  targeting: anotherSpaceship.
	aGame play: aCancellationCard  from: aSpaceship  targeting: anotherSpeedCard.

	aGame playTurn.
	aGame playTurn.
	self assert: (((aSpaceship position ) = 9) and: (( anotherSpaceship position ) = 6) )
]

{ #category : #tests }
CardTest >> test149CancellationCardCanRemoveActiveAccelerationCardsPlayedWithRedo [

	| aGame aSpaceship aBoard aDie  anAccelerationCard  aRedoCard aCancellationCard anotherSpaceship |
		aSpaceship := Spaceship launch: 'One' with: {SpeedCard . CancellationCard }.
	anotherSpaceship := Spaceship launch: 'Two' with: {AccelerationCard . RedoCard }.
	aBoard := self createBoardOf: 16 distance: 5 withEffects: {  } wormholeBeginsAt: 13 andEndsAt: 14.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 5).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	anAccelerationCard := AccelerationCard new.
	aCancellationCard  := CancellationCard new.
	aRedoCard := RedoCard new.
	
	aGame playTurn.
	
	aGame play: anAccelerationCard from: anotherSpaceship  targeting: anotherSpaceship.
	aGame play: aRedoCard  from: anotherSpaceship  targeting: anAccelerationCard .
	aGame play: aCancellationCard  from: aSpaceship  targeting: anAccelerationCard .

	aGame playTurn.
	aGame playTurn.
	self assert: (((aSpaceship position ) = 8) and: (( anotherSpaceship position) = 7) )
]

{ #category : #tests }
CardTest >> test150CancellationCardCanRemoveActiveMercenaryCardsPlayedWithRedo [

	| aGame aSpaceship aBoard aDie  aMercenaryCard anotherMercenaryCard aRedoCard aCancellationCard anotherSpaceship yetAnotherSpaceship|
	aSpaceship := Spaceship launch: 'One' with: {MercenaryCard . CancellationCard }.
	anotherSpaceship := Spaceship launch: 'Two' with: {AccelerationCard  . RedoCard  }.
	yetAnotherSpaceship := Spaceship randomCardsLaunch:  'Three'.
	aBoard := self createBoardOf: 16 distance: 5 withEffects: {  } wormholeBeginsAt: 13 andEndsAt: 14.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 5 with: 5 with: 4 with: 3).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship . yetAnotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aMercenaryCard  := MercenaryCard new.
	aCancellationCard  := CancellationCard new.
	aRedoCard := RedoCard new.
	
	aGame play: aMercenaryCard  from: aSpaceship targeting: anotherSpaceship.
	aGame playTurn.
	
	anotherMercenaryCard := aGame play: aRedoCard  from: anotherSpaceship  targeting: aSpaceship.
	aGame play: aCancellationCard  from: aSpaceship  targeting: anotherMercenaryCard.

	aGame playTurn.
	aGame playTurn.
	self assert: ((( anotherSpaceship position) = 1) and: ((yetAnotherSpaceship position ) = 6) )
]

{ #category : #tests }
CardTest >> test160ReversalCardCannotBePlayedOutOfTurn [

	| aGame aSpaceship aBoard aDie aReversalCard anEffect anotherSpaceship |
	aSpaceship := Spaceship launch: 'One' with: {
			              MercenaryCard.
			              ReversalCard }.
	anotherSpaceship := Spaceship randomCardsLaunch: ''.
	anEffect := NullEffect isIn: 5.
	aBoard := self
		          createBoardOf: 16
		          distance: 5
		          withEffects: { anEffect }
		          wormholeBeginsAt: 13
		          andEndsAt: 14.
	aDie := LoadedDie arrayOf: (OrderedCollection
			         with: 3
			         with: 5
			         with: 5
			         with: 4
			         with: 3).
	aGame := Game
		         playedBy: { aSpaceship . anotherSpaceship  }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aGame playTurn.
	aReversalCard := ReversalCard new.
	self
		should: [
		aGame play: aReversalCard from: aSpaceship targeting: anEffect ]
		raise: Error
		withMessage: 'Card cannot be played out of turn'
]

{ #category : #tests }
CardTest >> test161ReversalCardDoesNotChangeNullEffect [

	| aGame aSpaceship aBoard aDie aReversalCard anEffect |
	aSpaceship := Spaceship launch: 'One' with: {
			              MercenaryCard.
			              ReversalCard }.
	anEffect := NullEffect isIn: 5.
	aBoard := self
		          createBoardOf: 16
		          distance: 5
		          withEffects: { anEffect }
		          wormholeBeginsAt: 13
		          andEndsAt: 14.
	aDie := LoadedDie of: 4.
	aGame := Game
		         playedBy: { aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aReversalCard := ReversalCard new.
	aGame play: aReversalCard from: aSpaceship targeting: anEffect .
	aGame playTurn.
	
	self assert: aSpaceship position  equals: 5
]

{ #category : #tests }
CardTest >> test162ReversalCardDoesNotChangeAtomicBombEffect [

	| aGame aSpaceship aBoard aDie aReversalCard anEffect |
	aSpaceship := Spaceship launch: 'One' with: {
			              MercenaryCard.
			              ReversalCard }.
	anEffect := AtomicBombEffect  isIn: 5.
	aBoard := self
		          createBoardOf: 16
		          distance: 5
		          withEffects: { anEffect }
		          wormholeBeginsAt: 13
		          andEndsAt: 14.
	aDie := LoadedDie of: 4.
	aGame := Game
		         playedBy: { aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aReversalCard := ReversalCard new.
	aGame play: aReversalCard from: aSpaceship targeting: anEffect .
	aGame playTurn.
	
	self assert: aSpaceship position  equals: 1
]

{ #category : #tests }
CardTest >> test163WhenReversalCardIsPlayedOnBlackholeEffectThenSpaceshipMovesForwardFourSquares [

	| aGame aSpaceship aBoard aDie aReversalCard anEffect |
	aSpaceship := Spaceship launch: 'One' with: {
			              MercenaryCard.
			              ReversalCard }.
	anEffect := BlackholeEffect isIn: 5.
	aBoard := self
		          createBoardOf: 16
		          distance: 5
		          withEffects: { anEffect }
		          wormholeBeginsAt: 13
		          andEndsAt: 14.
	aDie := LoadedDie of: 4.
	aGame := Game
		         playedBy: { aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aReversalCard := ReversalCard new.
	aGame play: aReversalCard from: aSpaceship targeting: anEffect .
	aGame playTurn.
	
	self assert: aSpaceship position  equals: 9
]

{ #category : #tests }
CardTest >> test164ReversalCardStoresTheEffectItAppliesOn [

	| aGame aSpaceship aBoard aDie aReversalCard anEffect |
	aSpaceship := Spaceship launch: 'One' with: {
			              MercenaryCard.
			              ReversalCard }.
	anEffect := BlackholeEffect isIn: 5.
	aBoard := self
		          createBoardOf: 16
		          distance: 5
		          withEffects: { anEffect }
		          wormholeBeginsAt: 13
		          andEndsAt: 14.
	aDie := LoadedDie of: 4.
	aGame := Game
		         playedBy: { aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aReversalCard := ReversalCard new.
	aGame play: aReversalCard from: aSpaceship targeting: anEffect .
	aGame playTurn.
	
	self assert: aReversalCard effect  equals: anEffect 
]

{ #category : #tests }
CardTest >> test165WhenReversalCardIsPlayedOnMoonwalkEffectThenAllOtherSpaceshipsMoveForward [

	| aGame aSpaceship anotherSpaceship yetAnotherSpaceship aBoard aDie aReversalCard anEffect |
	aSpaceship := Spaceship launch: 'One' with: { ReversalCard }.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two' .
	yetAnotherSpaceship := Spaceship randomCardsLaunch:  'Three'.
	anEffect := MoonWalkEffect isIn: 5 moves: 1.
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of:  5)
		          withEffects: { anEffect }
		          wormholeBeginsAt: 13
		          andEndsAt: 14.
	aDie := LoadedDie of: 4.
	aGame := Game
		         playedBy: { aSpaceship . anotherSpaceship . yetAnotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aReversalCard := ReversalCard new.
	aGame play: aReversalCard from: aSpaceship targeting: anEffect .
	aGame playTurn.
	
	self assert: (anotherSpaceship position = 2 and: (yetAnotherSpaceship position = 2 and: (aSpaceship position = 5) ) )
]

{ #category : #tests }
CardTest >> test166WhenReversalCardIsPlayedOnHyperjumpEffectThenSpaceshipMovesSameAmountOfSquaresInTheOppositeDirection [

	| aGame aSpaceship aBoard aDie aReversalCard anEffect |
	aSpaceship := Spaceship launch: 'One' with: { ReversalCard }.
	
	anEffect := HyperJumpEffect isIn: 5 movesDistance: {ParsecDistance of: 2}.
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 16)
		          withEffects: { anEffect }
		          wormholeBeginsAt: 13
		          andEndsAt: 14.
	aDie := LoadedDie of: 4.
	aGame := Game
		         playedBy: { aSpaceship}
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aReversalCard := ReversalCard new.
	aGame play: aReversalCard from: aSpaceship targeting: anEffect .
	aGame playTurn.
	
	self assert: aSpaceship position equals: 3
]

{ #category : #tests }
CardTest >> test167WhenReversalCardIsPlayedOnHyperjumpEffectThatMovesBackwardsThenSpaceshipMovesSameAmountOfSquaresForward [

	| aGame aSpaceship aBoard aDie aReversalCard anEffect |
	aSpaceship := Spaceship launch: 'One' with: { ReversalCard }.
	
	anEffect := HyperJumpEffect isIn: 5 movesDistance: {ParsecDistance of: -2}.
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 16)
		          withEffects: { anEffect }
		          wormholeBeginsAt: 13
		          andEndsAt: 14.
	aDie := LoadedDie of: 4.
	aGame := Game
		         playedBy: { aSpaceship}
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aReversalCard := ReversalCard new.
	aGame play: aReversalCard from: aSpaceship targeting: anEffect .
	aGame playTurn.
	
	self assert: aSpaceship position equals: 7
]

{ #category : #tests }
CardTest >> test168WhenReversalCardIsPlayedOnHyperjumpEffectThenAllValuesGetInverted [

	| aGame aSpaceship aBoard aDie aReversalCard anEffect anotherSpaceship yetAnotherSpaceship |
	aSpaceship := Spaceship launch: 'One' with: { ReversalCard }.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two' .
	yetAnotherSpaceship := Spaceship randomCardsLaunch:  'Three'.
	
	anEffect := HyperJumpEffect isIn: 5 movesDistance: {ParsecDistance of: -2 . ParsecDistance of: 1 . ParsecDistance of: 3}.
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 16)
		          withEffects: { anEffect }
		          wormholeBeginsAt: 13
		          andEndsAt: 14.
	aDie := LoadedDie of: 4.
	aGame := Game
		         playedBy: { aSpaceship . anotherSpaceship . yetAnotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aReversalCard := ReversalCard new.
	aGame play: aReversalCard from: aSpaceship targeting: anEffect .
	3 timesRepeat: 	[aGame playTurn].
	
	self assert: (aSpaceship position = 7 and: (anotherSpaceship position = 4 and: yetAnotherSpaceship position = 2 ))
]

{ #category : #tests }
CardTest >> test169WhenReversalCardIsPlayedOnHyperSpacejumpEffectThenSpaceshipMovesBackFourSquares [

	| aGame aSpaceship aBoard aDie aReversalCard anEffect |
	aSpaceship := Spaceship launch: 'One' with: { ReversalCard }.
	
	anEffect := HyperSpaceJumpEffect  isIn: 5 .
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 16)
		          withEffects: { anEffect }
		          wormholeBeginsAt: 13
		          andEndsAt: 14.
	aDie := LoadedDie of: 4.
	aGame := Game
		         playedBy: { aSpaceship}
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aReversalCard := ReversalCard new.
	aGame play: aReversalCard from: aSpaceship targeting: anEffect .
	aGame playTurn.
	
	self assert: aSpaceship position equals: 1
]

{ #category : #tests }
CardTest >> test170WhenReversalCardIsPlayedOnHyperSpacejumpEffectThenSpaceshipGainsAShield [

	| aGame aSpaceship aBoard aDie aReversalCard anEffect |
	aSpaceship := Spaceship launch: 'One' with: { ReversalCard }.
	
	anEffect := HyperSpaceJumpEffect  isIn: 5 .
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 16)
		          withEffects: { anEffect }
		          wormholeBeginsAt: 13
		          andEndsAt: 14.
	aDie := LoadedDie of: 4.
	aGame := Game
		         playedBy: { aSpaceship}
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aReversalCard := ReversalCard new.
	aGame play: aReversalCard from: aSpaceship targeting: anEffect .
	aGame playTurn.
	
	self assert: aSpaceship shields equals: 4
]

{ #category : #tests }
CardTest >> test171WhenReversalCardIsPlayedOnWormholeEffectThenSpaceshipGoesToTheOtherSide [

	| aGame aSpaceship aBoard aDie aReversalCard anEffect |
	aSpaceship := Spaceship launch: 'One' with: { ReversalCard }.
	
	anEffect := WormholeEffect isIn: 5 goesTo: 10.
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 16)
		          withEffects: { anEffect }
		          wormholeBeginsAt: 13
		          andEndsAt: 14.
	aDie := LoadedDie of: 20.
	aGame := Game
		         playedBy: { aSpaceship}
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aReversalCard := ReversalCard new.
	aGame play: aReversalCard from: aSpaceship targeting: anEffect .
	aGame playTurn.
	
	self assert: aSpaceship position  equals: 10
]

{ #category : #tests }
CardTest >> test172WhenReversalCardIsPlayedOnWormholeEffectAndSpaceshipLandsInStartpointThenGoesToEndpointAndLosesALap [

	| aGame aSpaceship aBoard aDie aReversalCard anEffect |
	aSpaceship := Spaceship launch: 'One' with: { ReversalCard }.
	
	anEffect := WormholeEffect isIn: 5 goesTo: 10.
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 16)
		          withEffects: { anEffect }
		          wormholeBeginsAt: 13
		          andEndsAt: 14.
	aDie := LoadedDie of: 20.
	aGame := Game
		         playedBy: { aSpaceship}
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aReversalCard := ReversalCard new.
	aGame play: aReversalCard from: aSpaceship targeting: anEffect .
	aGame playTurn.
	
	self assert: (aSpaceship position = 10 and: (aSpaceship laps = 0) )
]

{ #category : #tests }
CardTest >> test173WhenReversalCardIsPlayedOnWormholeEffectAndSpaceshipLandsInEndpointThenGoesToStartpointAndGainsALap [

	| aGame aSpaceship aBoard aDie aReversalCard anEffect |
	aSpaceship := Spaceship launch: 'One' with: { ReversalCard }.
	
	anEffect := WormholeEffect isIn: 10 goesTo: 5.
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 16)
		          withEffects: { anEffect }
		          wormholeBeginsAt: 13
		          andEndsAt: 14.
	aDie := LoadedDie of: 9.
	aGame := Game
		         playedBy: { aSpaceship}
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aReversalCard := ReversalCard new.
	aGame play: aReversalCard from: aSpaceship targeting: anEffect .
	aGame playTurn.
	
	self assert: (aSpaceship position = 5 and: (aSpaceship laps = 1) )
]

{ #category : #tests }
CardTest >> test174WhenReversalCardIsPlayedOnMysteryCardEffectThenSpaceshipLosesARandomCard [

	| aGame aSpaceship aBoard aDie aReversalCard anEffect |
	aSpaceship := Spaceship launch: 'One' with: { ReversalCard . MercenaryCard . SpeedCard  }.
	
	anEffect := MysteryCardEffect  isIn: 10 .
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 16)
		          withEffects: { anEffect }
		          wormholeBeginsAt: 13
		          andEndsAt: 14.
	aDie := LoadedDie of: 9.
	aGame := Game
		         playedBy: { aSpaceship}
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aReversalCard := ReversalCard new.
	aGame play: aReversalCard from: aSpaceship targeting: anEffect .
	aGame playTurn.
	
	self assert: aSpaceship cards size equals: 1
]

{ #category : #tests }
CardTest >> test175WhenReversalCardIsPlayedOnMysteryCardEffectAndSpaceshipHasNoCardsLeftThenNothingHappens [

	| aGame aSpaceship aBoard aDie aReversalCard anEffect |
	aSpaceship := Spaceship launch: 'One' with: { ReversalCard }.
	
	anEffect := MysteryCardEffect  isIn: 10 .
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 16)
		          withEffects: { anEffect }
		          wormholeBeginsAt: 13
		          andEndsAt: 14.
	aDie := LoadedDie of: 9.
	aGame := Game
		         playedBy: { aSpaceship}
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aReversalCard := ReversalCard new.
	aGame play: aReversalCard from: aSpaceship targeting: anEffect .
	aGame playTurn.
	
	self assert: aSpaceship cards size equals: 0
]

{ #category : #tests }
CardTest >> test176WhenReversalCardIsPlayedOnWormholeEffectAndSpaceshipLandsInStartpointOnTheFirstLapThenGoesToSquareOne [

	| aGame aSpaceship aBoard aDie aReversalCard anEffect |
	aSpaceship := Spaceship launch: 'One' with: { ReversalCard }.
	
	anEffect := WormholeEffect isIn: 5 goesTo: 10.
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 16)
		          withEffects: { anEffect }
		          wormholeBeginsAt: 13
		          andEndsAt: 14.
	aDie := LoadedDie of: 4.
	aGame := Game
		         playedBy: { aSpaceship}
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aReversalCard := ReversalCard new.
	aGame play: aReversalCard from: aSpaceship targeting: anEffect .
	aGame playTurn.
	
	self assert: (aSpaceship position = 1 and: (aSpaceship laps = 0) )
]
