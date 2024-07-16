Class {
	#name : #BoardTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #accessing }
BoardTest >> createBoardOf: length distance: aDistance withEffects: someEffects wormholeBeginsAt: startPoint andEndsAt: endPoint [

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

{ #category : #tests }
BoardTest >> should: anErrorBlock raise: anError withMessage: errorMessage [

self 
	should: anErrorBlock 
	raise: anError 
	withExceptionDo: [ :error |
										self assert: error messageText  equals: errorMessage  ].
]

{ #category : #tests }
BoardTest >> test007BoardCreatedWithTwoSquares [

	| aBoard |

	aBoard := Board of: 2 wormholeBeginsAt: 1 andEndsAt: 2.
	self assert: aBoard lengthInSquares  equals: 2
]

{ #category : #tests }
BoardTest >> test010BoardCreatedWithNSquares [

| aBoard |

aBoard := Board of: 20 wormholeBeginsAt: 1 andEndsAt: 2.
self assert: aBoard lengthInSquares  equals: 20.
]

{ #category : #tests }
BoardTest >> test013IfSpaceshipLandsOnWormholeInSquareFourPlayerGetsMovedToSquareFive [

	| aSpaceship aLoadedDie aGame aBoard  someDice |
	aSpaceship := Spaceship randomCardsLaunch: ''  .
	
	aBoard := Board of: 6 wormholeBeginsAt: 4 andEndsAt: 5.
	aLoadedDie := LoadedDie of: 3.
	someDice := OrderedCollection with: aLoadedDie.
	aGame := Game
		         playedBy: {aSpaceship } 
		         on: aBoard
		         throwing: someDice
		         wonAfter: 1.
	aGame playTurn.

	self assert: ( aSpaceship position ) equals: 5
]

{ #category : #tests }
BoardTest >> test014IfSpaceshipLandsOnWormholeStartingPointEndsInEndpoint [

	| aSpaceship aLoadedDie aGame aBoard someDice  |
	aSpaceship := Spaceship randomCardsLaunch: ''.
	
	aBoard := Board of: 10 wormholeBeginsAt: 4 andEndsAt: 7.
	aLoadedDie := LoadedDie of: 3.
	someDice := OrderedCollection with: aLoadedDie.
	aGame := Game
		         playedBy: { aSpaceship  } 
		         on: aBoard
		         throwing: someDice
		         wonAfter: 1.

	aGame playTurn.


	self assert: (aSpaceship position ) equals: 7
]

{ #category : #tests }
BoardTest >> test015IfSpaceshipLandsOnWormholeEndpointEndsInStartingPoint [

	| aSpaceship aLoadedDie aGame aBoard someDice |
	
	aBoard := Board of: 10 wormholeBeginsAt: 3 andEndsAt: 7.
	aLoadedDie := LoadedDie of: 6.
	someDice := OrderedCollection with: aLoadedDie.
	aSpaceship := Spaceship randomCardsLaunch: ''.
	aGame := Game
		         playedBy: {aSpaceship } 
		         on: aBoard
		         throwing: someDice
		         wonAfter: 1.

	aGame playTurn.


	self assert: (aSpaceship position ) equals: 3
]

{ #category : #tests }
BoardTest >> test032BoardMustBeCreatedWithAtLeastOneSquare [

	| aBoard |
	
	self should: [ aBoard := Board of: 0 wormholeBeginsAt: 0 andEndsAt: 0. ] raise: Error withMessage: 'Board must have at least 1 square'.
]

{ #category : #tests }
BoardTest >> test033BoardCannotBeCreatedIfWormholeIsOutOfBounds [

	| aBoard |
	
	self should: [ aBoard := Board of: 1 wormholeBeginsAt: 2 andEndsAt: 3. ] raise: Error withMessage: 'Wormhole out of bounds'. 
]

{ #category : #tests }
BoardTest >> test034BoardCannotBeCreatedIfWormholeEndpointsAreNegative [

	| aBoard |
	

	self should: [ aBoard := Board of: 1 wormholeBeginsAt: -1 andEndsAt: -2. ] raise: Error withMessage: 'Wormhole out of bounds'.  
]

{ #category : #tests }
BoardTest >> test035BoardCannotBeCreatedIfWormholeEndpointsAreInTheSameSquare [

	| aBoard | 

	self should: [ aBoard := Board of: 3 wormholeBeginsAt: 1 andEndsAt: 1. ] raise: Error withMessage: 'Wormhole endpoints cannot be in the same square'.  
]

{ #category : #tests }
BoardTest >> test037WhenSpaceshipPassesFinalSquareThenGoesBackToBeginning [

	| aGame aSpaceship aBoard aDie  |
	aBoard := Board of: 7 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie of: 9.

	aSpaceship := Spaceship randomCardsLaunch: ''.
	aGame := Game
		         playedBy: {aSpaceship } 
		         on: aBoard
		         throwing: {aDie} 
		         wonAfter: 1.

	aGame playTurn.
	self assert: (aSpaceship position ) equals: 3
]

{ #category : #tests }
BoardTest >> test038WhenSpaceshipMovesTenInBoardOfEightThenGoesToSquareThree [

	| aGame aSpaceship aBoard aDie |

	aBoard := Board of: 8 wormholeBeginsAt: 6 andEndsAt: 7.
	aDie := LoadedDie of: 9.
	aSpaceship := Spaceship randomCardsLaunch: ''.
	aGame := Game
		         playedBy: {aSpaceship } 
		         on: aBoard
		         throwing: {aDie }
		         wonAfter: 1.

	aGame playTurn.
	self assert: (aSpaceship position ) equals: 2
]

{ #category : #tests }
BoardTest >> test055WhenLandingInABlackholeSpaceshipGoesBackFourSquares [

	| aGame aSpaceship aBoard aDie |
	
	aBoard := self createBoardOf: 10 distance: (ParsecDistance of: 10) withEffects: { (BlackholeEffect isIn: 6) }  wormholeBeginsAt: 1 andEndsAt: 3.
	aDie := LoadedDie of: 5.
	aSpaceship := Spaceship randomCardsLaunch: ''.
	aGame := Game
		         playedBy: {aSpaceship } 
		         on: aBoard
		         throwing: {aDie }
		         wonAfter: 1.
	aGame playTurn.
	self assert: (aSpaceship position ) equals: 2
]

{ #category : #tests }
BoardTest >> test056IfSpaceshipLandsOnHyperSpaceJumpSquareThenAdvancesFourSquares [

	| aGame aSpaceship aBoard aDie  |
	aBoard := self createBoardOf: 11 distance: (ParsecDistance of: 1) withEffects: { ( HyperSpaceJumpEffect isIn: 6) } wormholeBeginsAt: 1 andEndsAt: 3.

	aDie := LoadedDie of: 5.
	aSpaceship := Spaceship randomCardsLaunch: ''.
	aGame := Game
		         playedBy: {aSpaceship } 
		         on: aBoard
		         throwing: {aDie }
		         wonAfter: 1.
	aGame playTurn.
	self assert: ( aSpaceship position ) equals: 10
]

{ #category : #tests }
BoardTest >> test057IfSpaceshipLandsOnHyperSpaceJumpSquareThenLosesAShield [

	| aGame aSpaceship  aBoard aDie  |
	aBoard := self createBoardOf: 11 distance: (ParsecDistance of: 1) withEffects: { ( HyperSpaceJumpEffect isIn: 6) } wormholeBeginsAt: 1 andEndsAt: 3.

	aDie := LoadedDie of: 5.
	aSpaceship := Spaceship randomCardsLaunch: ''.
	aGame := Game
		         playedBy: {aSpaceship } 
		         on: aBoard
		         throwing: {aDie }
		         wonAfter: 1.
	aGame playTurn.
	self assert: (aSpaceship shields) equals: 2
]

{ #category : #tests }
BoardTest >> test058WhenSpaceshipLandsOnMoonWalkSquareThenOtherSpaceshipsGetSentBackN [

	| aGame aSpaceship anotherSpaceship aBoard aDie |
	aBoard := self createBoardOf: 11 distance: (ParsecDistance of: 1) withEffects: (OrderedCollection with: (MoonWalkEffect isIn: 6 moves: 3)) wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 5).
	aSpaceship := Spaceship randomCardsLaunch: 'One'.
	anotherSpaceship  := Spaceship randomCardsLaunch: 'Two'.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship  } 
		         on: aBoard
		         throwing: {aDie }
		         wonAfter: 1.
	aGame playTurn.
	aGame playTurn.
	self assert: (aSpaceship position ) equals: 1
	
]

{ #category : #tests }
BoardTest >> test059WhenSpaceshipLandsOnMoonwalkSquareThenItDoesntMove [

	| aGame aSpaceship anotherSpaceship aBoard aDie |
	aBoard := self createBoardOf: 11 distance: (ParsecDistance of: 1) withEffects: (OrderedCollection with: (MoonWalkEffect isIn: 6 moves: 3)) wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 5).
	aSpaceship := Spaceship randomCardsLaunch: 'One'.
	anotherSpaceship  := Spaceship randomCardsLaunch: 'Two'.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship  } 
		         on: aBoard
		         throwing: {aDie }
		         wonAfter: 1.
	aGame playTurn.
	aGame playTurn.
	self assert: (anotherSpaceship position ) equals: 6
]

{ #category : #tests }
BoardTest >> test060WhenSpaceshipLandsOnAtomicBombSquareThenGetsSentBackToBeginning [

	| aGame aSpaceship aDie aBoard |
	aDie := LoadedDie of: 5.
	aBoard := self createBoardOf: 10 distance: (ParsecDistance of: 1) withEffects: (OrderedCollection with: (AtomicBombEffect isIn: 6)) wormholeBeginsAt: 1 andEndsAt: 2.
		aSpaceship := Spaceship randomCardsLaunch: ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame playTurn.

	self assert: (aSpaceship position ) equals: 1
]

{ #category : #tests }
BoardTest >> test061WhenSpaceshipLandsOnAtomicBombEffectThenEveryoneGetsSentToSquareOne [

	| aGame aSpaceship anotherSpaceship aBoard aDie  |
	aBoard := self createBoardOf: 11 distance: (ParsecDistance of: 1) withEffects: (OrderedCollection with: (AtomicBombEffect isIn: 6)) wormholeBeginsAt: 1 andEndsAt: 2.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 5).
	aSpaceship := Spaceship randomCardsLaunch: 'One'.
	anotherSpaceship  := Spaceship randomCardsLaunch: 'Two'.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship  } 
		         on: aBoard
		         throwing: {aDie }
		         wonAfter: 1.
	aGame playTurn.
	aGame playTurn.

	self assert: (( anotherSpaceship position) = 1 and:
			 ( aSpaceship position ) = 1)
]

{ #category : #tests }
BoardTest >> test062WhenSpaceshipLandsOnAtomicBombAllShieldsGetReducedByOne [

	| aGame aSpaceship anotherSpaceship aBoard aDie  |
	aBoard := self createBoardOf: 11 distance: (ParsecDistance of: 1) withEffects: (OrderedCollection with: (AtomicBombEffect isIn: 6)) wormholeBeginsAt: 1 andEndsAt: 2.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 5).
	aSpaceship := Spaceship randomCardsLaunch: 'One'.
	anotherSpaceship  := Spaceship randomCardsLaunch: 'Two'.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship  } 
		         on: aBoard
		         throwing: {aDie }
		         wonAfter: 1.
	aGame playTurn.
	aGame playTurn.

	self assert: ((aSpaceship  shields ) = 2 and:
			 (anotherSpaceship  shields) = 2)
]

{ #category : #tests }
BoardTest >> test063WhenSpaceshipLandsOnAtomicBombAllShieldsGoDownByOne [

	| aGame aSpaceship anotherSpaceship aBoard aDie atomicBombEffect |
	
	atomicBombEffect := (AtomicBombEffect isIn: 6).
	aBoard := self
		          createBoardOf: 16
		          distance: (ParsecDistance of: 1)
		          withEffects: (OrderedCollection with: atomicBombEffect)
		          wormholeBeginsAt: 13
		          andEndsAt: 14.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 5).
	
	aSpaceship := Spaceship randomCardsLaunch: 'One'.
	anotherSpaceship  := Spaceship randomCardsLaunch: 'Two'.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship  } 
		         on: aBoard
		         throwing: {aDie }
		         wonAfter: 1.
	aGame playTurn.
	aGame decreaseShieldByOneOf: anotherSpaceship .
	aGame playTurn.

	self assert: ((anotherSpaceship  shields ) = 1 and:
			 (aSpaceship  shields ) = 2)
]

{ #category : #tests }
BoardTest >> test064WhenTwoSpaceshipLandOnAnEffectSquareThenTheEffectsHappensBeforeBattle [

	| aGame aSpaceship anotherSpaceship aBoard aDie  |
	aBoard := self createBoardOf: 11 distance: (ParsecDistance of: 1) withEffects: (OrderedCollection with: (MoonWalkEffect isIn: 6 moves: 3)) wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 3 with: 5).
	aSpaceship := Spaceship randomCardsLaunch: 'One'.
	anotherSpaceship  := Spaceship randomCardsLaunch: 'Two'.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship  } 
		         on: aBoard
		         throwing: {aDie }
		         wonAfter: 1.
	
	3 timesRepeat: [ aGame playTurn ].


	self assert: (aSpaceship  shields ) equals: 3
]

{ #category : #tests }
BoardTest >> test065WhenSpaceshipLandsOnSquareWithEffectAndGetsMovedToASquareWithAnotherSpaceshipThenTheyBattle [

	| aGame aSpaceship anotherSpaceship aBoard aDie |
	
	aBoard := self createBoardOf: 11 distance: (ParsecDistance of: 1) withEffects: (OrderedCollection with: (BlackholeEffect isIn: 6)) wormholeBeginsAt: 3 andEndsAt: 4.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 1 with: 5 with: 6).
		
	aSpaceship := Spaceship randomCardsLaunch: 'One'.
	anotherSpaceship  := Spaceship randomCardsLaunch: 'Two'.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship  } 
		         on: aBoard
		         throwing: {aDie }
		         wonAfter: 1.
	2 timesRepeat: [ aGame playTurn ].

	self assert: (aSpaceship shields ) equals: 2
]

{ #category : #tests }
BoardTest >> test068WhenSpaceshipLandsOnHyperJumpSquareGetsMovedOneParsecAhead [

	| aGame aSpaceship aBoard aDie aParsecDistance |
	
	aParsecDistance := ParsecDistance of: 1.
	aBoard := self createBoardOf: 11 distance: (ParsecDistance of: 1) withEffects: (OrderedCollection with: (HyperJumpEffect isIn: 6 movesDistance: (OrderedCollection with: aParsecDistance))) wormholeBeginsAt: 1 andEndsAt: 2.

	aDie := LoadedDie of: 5.
	aSpaceship := Spaceship randomCardsLaunch: ''.
	aGame := Game
		         playedBy: {aSpaceship } 
		         on: aBoard
		         throwing: {aDie }
		         wonAfter: 1.
	aGame playTurn.

	self assert: ( aSpaceship position ) equals: 6
]

{ #category : #tests }
BoardTest >> test070HyperJumpStoresAnArrayOfParsecsAndLoopsThroughThem [

	| aGame aSpaceship anotherSpaceship yetAnotherSpaceship aBoard aDie aParsecDistance anotherParsecDistance  |
	aSpaceship := Spaceship randomCardsLaunch:  'One'.
	anotherSpaceship := Spaceship randomCardsLaunch: 'Two'.
	yetAnotherSpaceship := Spaceship randomCardsLaunch: 'Three'.
	aParsecDistance := ParsecDistance of: -1.
	anotherParsecDistance := ParsecDistance of: 2.
	aBoard := self
		          createBoardOf: 11
		          distance: (ParsecDistance of: 11)
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
		         playedBy: {aSpaceship . anotherSpaceship . yetAnotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	self assert: (( aSpaceship position ) = 5 and:
			 (( anotherSpaceship position ) = 8 and:
				  ( yetAnotherSpaceship position ) = 1))
]

{ #category : #tests }
BoardTest >> test071WhenSpaceshipLandsOnHyperJumpSquareGetsMovedOneParsecAndFourSquares [

	| aGame aSpaceship aBoard aDie aParsecDistance |
	aParsecDistance := ParsecDistance of: 1.
	aBoard := self
		          createBoardOf: 20
		          distance: (ParsecDistance of: 5)
		          withEffects: (OrderedCollection with: (HyperJumpEffect
					            isIn: 6
					            movesDistance:
					            (OrderedCollection
						             with: aParsecDistance
						             )))
		          wormholeBeginsAt: 1
		          andEndsAt: 2.

	aDie := LoadedDie of: 5.
	aSpaceship := Spaceship randomCardsLaunch: ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame playTurn.

	self assert: ( aSpaceship position ) equals: 10
]

{ #category : #tests }
BoardTest >> test072WhenBoardHasMoreParsecsThanSquaresThenSpaceshipMovesTwoParsecsAndOneSquare [

	| aGame aSpaceship aBoard aDie aParsecDistance |
	aParsecDistance := ParsecDistance of: 2.

	aBoard := self
		          createBoardOf: 20
		          distance: (ParsecDistance of: 40)
		          withEffects: (OrderedCollection with: (HyperJumpEffect
					            isIn: 6
					            movesDistance:
					            (OrderedCollection
						             with: aParsecDistance
						             )))
		          wormholeBeginsAt: 1
		          andEndsAt: 2.

	aDie := LoadedDie of: 5.
	aSpaceship := Spaceship randomCardsLaunch: ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame playTurn.

	self assert: (aSpaceship position ) equals: 7
]

{ #category : #tests }
BoardTest >> test073SpaceshipOnlyMovesWhenParsecsToSquaresRatioIsAnEvenNumber [

	| aGame aSpaceship aBoard aDie aParsecDistance |
	
	aParsecDistance := ParsecDistance of: 3.

	aBoard := self
		          createBoardOf: 20
		          distance: (ParsecDistance of: 40)
		          withEffects: (OrderedCollection with: (HyperJumpEffect
					            isIn: 6
					            movesDistance:
					            (OrderedCollection
						             with: aParsecDistance
						             )))
		          wormholeBeginsAt: 1
		          andEndsAt: 2.

	aDie := LoadedDie of: 5.
	aSpaceship := Spaceship randomCardsLaunch: ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame playTurn.

	self assert: ( aSpaceship position ) equals: 7
]

{ #category : #tests }
BoardTest >> test074SpaceshipLosesALapIfItGetsSentBackPastTheFirstSquare [

	| aGame aSpaceship aBoard aDie |
	
	aBoard := self
		          createBoardOf: 20
		          distance: (ParsecDistance of: 1)
		          withEffects: (OrderedCollection with: (BlackholeEffect 
					            isIn: 2
					            ))
		          wormholeBeginsAt: 1
		          andEndsAt: 2.

	aDie := LoadedDie of: 5.
	aSpaceship := Spaceship randomCardsLaunch: ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame playTurn.

	self assert: (aSpaceship laps ) equals: 0
]

{ #category : #tests }
BoardTest >> test075SpaceshipCantGoBackFurtherThanTheFirstSquareOnTheFirstLap [

	| aGame aSpaceship aBoard aDie |
	aBoard := self createBoardOf: 5 distance: (ParsecDistance of: 5) withEffects: { HyperJumpEffect isIn: 4 movesDistance: (OrderedCollection with: (ParsecDistance of: -5)) }  wormholeBeginsAt: 1 andEndsAt: 2.

	aDie := LoadedDie of: 3.
	aSpaceship := Spaceship randomCardsLaunch: ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame playTurn.

	self assert: ( aSpaceship position ) equals: 1
]

{ #category : #tests }
BoardTest >> test076IfSpaceshipCompletesALapAndGoesBackBeyondTheFirstSquareThenItLosesTheLap [

	| aGame aSpaceship aBoard aDie |
	
	aBoard := self createBoardOf: 10 distance: 10 withEffects: { BlackholeEffect isIn: 2 } wormholeBeginsAt: 8 andEndsAt: 9.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 5 with: 2).
	aSpaceship := Spaceship randomCardsLaunch: ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 2.
	aGame playTurn.
	aGame playTurn.
	self assert: (aSpaceship  laps ) equals: 0
]

{ #category : #tests }
BoardTest >> test077WhenSpaceshipGoesBackMultipleLapsWithMoonwalkEffectThenLosesThoseLaps [

	| aGame aSpaceship anotherSpaceship aBoard aDie moonwalkEffect  |
	aSpaceship := Spaceship randomCardsLaunch:  'One'.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	moonwalkEffect :=( MoonWalkEffect isIn: 4 moves: 10).
	aBoard := self
		          createBoardOf: 5
		          distance: (ParsecDistance of: 1)
		          withEffects: (OrderedCollection with: moonwalkEffect)
		          wormholeBeginsAt: 2
		          andEndsAt: 3.

	aDie := LoadedDie arrayOf: (OrderedCollection with: 10 with: 3).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aGame playTurn.
	aGame playTurn.
	self assert: (aSpaceship  laps ) equals: 0
]

{ #category : #tests }
BoardTest >> test081HyperJumpEffectCanJumpLightyears [

	| aGame aSpaceship aBoard aDie aLightyearDistance  |
	aLightyearDistance := LightyearDistance of: 9.
	
	aBoard := self
		          createBoardOf: 12
		          distance: (ParsecDistance of: 4)
		          withEffects: (OrderedCollection with: (HyperJumpEffect  
					            isIn: 4
									movesDistance: (OrderedCollection with: aLightyearDistance)
					            ))
		          wormholeBeginsAt: 2
		          andEndsAt: 3.

	aDie := LoadedDie of: 3.
	
	aSpaceship := Spaceship randomCardsLaunch: ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aGame playTurn.

	self assert: ( aSpaceship position ) equals: 1
]

{ #category : #tests }
BoardTest >> test082HyperJumpEffectStoresParsecAndLightYearArray [

	| aGame aSpaceship aBoard aDie aLightyearDistance aParsecDistance  |
	
	aLightyearDistance := LightyearDistance of: 6.
	aParsecDistance := ParsecDistance of: 2.
	
	aBoard := self
		          createBoardOf: 5
		          distance: (ParsecDistance of: 5)
		          withEffects: (OrderedCollection with: (HyperJumpEffect  
					            isIn: 4
									movesDistance: (OrderedCollection with: aLightyearDistance with: aParsecDistance)
					            ))
		          wormholeBeginsAt: 2
		          andEndsAt: 3.

	aDie := LoadedDie of: 3.
	aSpaceship := Spaceship randomCardsLaunch: ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aGame playTurn.
	aGame playTurn.
	self assert: (aSpaceship position ) equals: 1
]

{ #category : #tests }
BoardTest >> test121WhenSpaceshipUsesRepeatCardAndMovesFurtherThanTheLastSquareThenGainsALap [

	| aGame aSpaceship anotherSpaceship yetAnotherSpaceship aCard aBoard aDie |
	aSpaceship := Spaceship randomCardsLaunch:  'One'.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	yetAnotherSpaceship := Spaceship launch: 'Three' with:  (OrderedCollection
					                    with: RepeatCard
					                    with: RedoCard) .
	aBoard := self
		          createBoardOf: 6
		          distance: (ParsecDistance of: 6)
		          withEffects: { (HyperJumpEffect
				           isIn: 4
				           movesDistance:
				           (OrderedCollection with: (ParsecDistance of: 7))) }
		          wormholeBeginsAt: 1
		          andEndsAt: 2.
	aDie := LoadedDie of: 3.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship . yetAnotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aCard := RepeatCard new.
	aGame playTurn.
	aGame
		play: aCard
		from: yetAnotherSpaceship
		targeting: yetAnotherSpaceship.

	self assert: (yetAnotherSpaceship  laps ) equals: 1
]

{ #category : #tests }
BoardTest >> test131WhenBoardWithFiveSquaresAndFiveParsecsReturnsLengthInParsecsEqualsToFive [

	| aBoard |
	aBoard := self createBoardOf: 5 distance: (ParsecDistance of: 5) withEffects: OrderedCollection new wormholeBeginsAt: 3 andEndsAt: 4.
	self assert: aBoard lengthInParsecs  equals: 5.
]

{ #category : #tests }
BoardTest >> test132BoardWithFiveParsecsEqualsFifteenLightYears [

	| aBoard |
	aBoard := self createBoardOf: 5 distance: (ParsecDistance of: 5) withEffects: OrderedCollection new wormholeBeginsAt: 3 andEndsAt: 4.
	self assert: aBoard lengthInLightYears  equals: 15.
]

{ #category : #tests }
BoardTest >> test133LengthInLightYearsEqualsThreeTimesLengthInParsecs [

	| aBoard |
	aBoard := self createBoardOf: 5 distance: (ParsecDistance of: 6) withEffects: OrderedCollection new wormholeBeginsAt: 3 andEndsAt: 4.
	self assert: aBoard lengthInLightYears  equals: 18.
]

{ #category : #tests }
BoardTest >> test134BoardCanExpressItsLengthInParsecs [

	| aBoard |
	aBoard := self createBoardOf: 5 distance: (ParsecDistance of: 6) withEffects: OrderedCollection new wormholeBeginsAt: 3 andEndsAt: 4.
	self assert: aBoard lengthInParsecs equals: 6.
]

{ #category : #tests }
BoardTest >> test135BoardCreatedWithAParsecDistance [

	| aBoard aParsecDistance |
	aParsecDistance := ParsecDistance of: 6.
	aBoard := self createBoardOf: 5 distance: aParsecDistance withEffects: OrderedCollection new wormholeBeginsAt: 3 andEndsAt: 4.
	self assert: aBoard lengthInParsecs equals: 6.
	
]

{ #category : #tests }
BoardTest >> test136BoardCreatedWithLightYearsDistance [

	| aBoard aLightYearsDistance |
	aLightYearsDistance := LightyearDistance of: 6.
	aBoard := self createBoardOf: 5 distance: aLightYearsDistance withEffects: OrderedCollection new wormholeBeginsAt: 3 andEndsAt: 4.
	self assert: aBoard lengthInLightYears equals: 6.
	
]

{ #category : #tests }
BoardTest >> test177BoardKnowsTheDistanceBetweenTwoSquaresPassingThroughTheBeginning [

	| aBoard aLightYearsDistance |
	aLightYearsDistance := LightyearDistance of: 6.
	aBoard := self createBoardOf: 5 distance: aLightYearsDistance withEffects: OrderedCollection new wormholeBeginsAt: 3 andEndsAt: 4.
	self assert: (aBoard distanceBetween: 3 and: 5) equals: -3.
	
]

{ #category : #tests }
BoardTest >> test178BoardKnowsTheDistanceBetweenTwoSquaresPassingThroughTheBeginning [

	| aBoard aLightYearsDistance |
	aLightYearsDistance := LightyearDistance of: 6.
	aBoard := self createBoardOf: 10 distance: aLightYearsDistance withEffects: OrderedCollection new wormholeBeginsAt: 3 andEndsAt: 4.
	self assert: (aBoard distanceBetween: 6 and: 4) equals: 8.
	
]

{ #category : #tests }
BoardTest >> test184WormholeCanCalculateHash [

	| aWormholeEffect |
	aWormholeEffect := WormholeEffect isIn: 1 goesTo: 2.
	self assert: aWormholeEffect hash >0 
	
]
