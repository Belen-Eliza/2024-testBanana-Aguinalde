Class {
	#name : #GameTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #accessing }
GameTest >> createBoardOf: length distance: aDistance withEffects: someEffects wormholeBeginsAt: startPoint andEndsAt: endPoint [

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
GameTest >> should: anErrorBlock raise: anError withMessage: errorMessage [

self 
	should: anErrorBlock 
	raise: anError 
	withExceptionDo: [ :error |
										self assert: error messageText  equals: errorMessage  ].
]

{ #category : #tests }
GameTest >> test001WhenGameStartedThenIsOngoing [
	"Let the games begin"

	| aGame aSpaceship aBoard |
	aBoard := self createBoardOf: 4 distance: (ParsecDistance of: 2)  withEffects: {  }  wormholeBeginsAt: 2 andEndsAt: 3.
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection new)
		         wonAfter: 1.
	^ self assert: aGame isOngoing
]

{ #category : #tests }
GameTest >> test002WhenGameEndsThenIsOver [

	| aGame aSpaceship  aBoard |
	
	aBoard := self createBoardOf: 4 distance: (ParsecDistance of: 2)  withEffects: {  }  wormholeBeginsAt: 2 andEndsAt: 3.
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection new)
		         wonAfter: 1.
	aGame end.

	self deny: aGame isOngoing
]

{ #category : #tests }
GameTest >> test003GameBeginsWithAPlayer [

	| aGame aSpaceship aBoard |
	
	aBoard := self createBoardOf: 4 distance: (ParsecDistance of: 2)  withEffects: {  }  wormholeBeginsAt: 2 andEndsAt: 3.
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection new)
		         wonAfter: 1.
	self
		assert: aGame players
		equals: (OrderedCollection with: aSpaceship)
]

{ #category : #tests }
GameTest >> test004SpaceshipChangedPositionByOneWhenMoved [

	| aSpaceship aGame aBoard|
	
	aBoard := self createBoardOf: 5 distance: 5 withEffects: {  }  wormholeBeginsAt: 3 andEndsAt: 4.
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection new)
		         wonAfter: 1.
	aGame move: aSpaceship to: 1.
	self assert: ( aSpaceship position ) equals: 1
]

{ #category : #tests }
GameTest >> test005SpaceshipIsCreatedAtStartPoint [

	| aSpaceship aGame aBoard |
	
	aBoard := self createBoardOf: 4 distance: (ParsecDistance of: 2)  withEffects: {  }  wormholeBeginsAt: 2 andEndsAt: 3.
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection new)
		         wonAfter: 1.

	self assert: ( aSpaceship position ) equals: 1
]

{ #category : #tests }
GameTest >> test006WhenGameHasOnlyOnePlayerThenThatPlayerWins [

	| aGame aSpaceship aBoard aDie |
	
	aBoard := Board of: 6 wormholeBeginsAt: 3 andEndsAt: 4.
	aDie := LoadedDie of: 8.
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie )
		         wonAfter: 1.
	aGame playTurn .
	self assert: aGame winner equals: aSpaceship
]

{ #category : #tests }
GameTest >> test008WhenGameIsOngoingThereIsNoWinner [

	| aGame aSpaceship aBoard |
	
	aBoard := self createBoardOf: 4 distance: (ParsecDistance of: 2)  withEffects: {  }  wormholeBeginsAt: 2 andEndsAt: 3.
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection new)
		         wonAfter: 1.

	self
		should: [ aGame winner ]
		raise: Error
		withMessage: 'The game is not over - there is no winner yet.'
]

{ #category : #tests }
GameTest >> test009SpaceshipDoesNotWinUntilItLandsOnTheLastSquare [

	| aGame aSpaceship aBoard |
	aSpaceship := Spaceship randomCardsLaunch:  ''.

	aBoard := Board of: 2 wormholeBeginsAt: 1 andEndsAt: 2.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection new)
		         wonAfter: 1.

	aGame end.

	self should: [ aGame winner equals: aSpaceship ] raise: NotFound
]

{ #category : #tests }
GameTest >> test011ASpaceshipMovesFiveSquaresWhenLoadedDieIsThrown [

	| aSpaceship aLoadedDie aBoard aGame |
	
	aLoadedDie := LoadedDie of: 5.

	aBoard := Board of: 10 wormholeBeginsAt: 2 andEndsAt: 7.
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aLoadedDie  )
		         wonAfter: 1.
	aGame playTurn.
	self assert: (aSpaceship position ) equals: 6
]

{ #category : #tests }
GameTest >> test012ASpaceshipMovesSevenSquaresWhenLoadedDieIsThrown [

	| aSpaceship aLoadedDie aBoard aGame |
	
	aLoadedDie := LoadedDie of: 7.

	aBoard := Board of: 10 wormholeBeginsAt: 2 andEndsAt: 3.
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aLoadedDie  )
		         wonAfter: 1.
	aGame playTurn.
	self assert: ( aSpaceship position ) equals: 8
]

{ #category : #tests }
GameTest >> test016GameIndicatesTurnWithOnePlayer [

	| aGame aSpaceship aBoard |
	
	aBoard := self createBoardOf: 4 distance: (ParsecDistance of: 2)  withEffects: {  }  wormholeBeginsAt: 2 andEndsAt: 3.
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection new )
		         wonAfter: 1.
	self assert: aGame nextSpaceshipToPlay equals: aSpaceship
]

{ #category : #tests }
GameTest >> test017GameIndicatesFirstTurnWithTwoPlayers [

	| aGame aSpaceship anotherSpaceship aBoard |
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	anotherSpaceship := Spaceship randomCardsLaunch:  ''.
	aBoard := self createBoardOf: 4 distance: (ParsecDistance of: 2)  withEffects: {  }  wormholeBeginsAt: 2 andEndsAt: 3.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship } 
		         on: aBoard 
		         throwing: (OrderedCollection new)
		         wonAfter: 1.
	self assert: aGame nextSpaceshipToPlay equals: aSpaceship
]

{ #category : #tests }
GameTest >> test018GameIndicatesSecondTurnWithTwoPlayers [

	| aGame aSpaceship anotherSpaceship aBoard |
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	anotherSpaceship := Spaceship randomCardsLaunch:  ''.
	aBoard := self createBoardOf: 4 distance: (ParsecDistance of: 2)  withEffects: {  }  wormholeBeginsAt: 2 andEndsAt: 3.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship } 
		         on: aBoard 
		         throwing: (OrderedCollection new)
		         wonAfter: 1.
	aGame nextTurn.
	self assert: aGame nextSpaceshipToPlay equals: anotherSpaceship
]

{ #category : #tests }
GameTest >> test019GameResetsTurnsForNextRound [

	| aGame aSpaceship anotherSpaceship aBoard |
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	anotherSpaceship := Spaceship randomCardsLaunch:  ''.
	aBoard := self createBoardOf: 4 distance: (ParsecDistance of: 2)  withEffects: {  }  wormholeBeginsAt: 2 andEndsAt: 3.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship } 
		         on: aBoard 
		         throwing: (OrderedCollection new)
		         wonAfter: 1.
	aGame
		nextTurn;
		nextTurn.
	self assert: aGame nextSpaceshipToPlay equals: aSpaceship
]

{ #category : #tests }
GameTest >> test020GameWithMultiplePlayersKnowsTheWinner [

	| aGame aSpaceship anotherSpaceship aBoard aLoadedDie someDice |
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	anotherSpaceship := Spaceship randomCardsLaunch:  ''.
	aLoadedDie := LoadedDie of: 12.
	someDice := OrderedCollection with: aLoadedDie.
	aBoard := Board of: 10 wormholeBeginsAt: 2 andEndsAt: 3.
	aGame := Game
		         playedBy: { aSpaceship . anotherSpaceship  }
		         on: aBoard
		         throwing: someDice
		         wonAfter: 1.
	aGame playTurn.
	aGame end.

	self assert: aGame winner equals: aSpaceship
]

{ #category : #tests }
GameTest >> test021WhenGameIsOverLeaderboardIsShown [

	| aGame aSpaceship anotherSpaceship aBoard aLoadedDie someDice |
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	anotherSpaceship := Spaceship randomCardsLaunch:  ''.
	aBoard := Board of: 6 wormholeBeginsAt: 1 andEndsAt: 2.
	aLoadedDie := LoadedDie of: 4.
	someDice := OrderedCollection with: aLoadedDie.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: someDice
		         wonAfter: 1.
	aGame playTurn.
	aGame playTurn.

	self
		assert: aGame leaderBoard asOrderedCollection
		equals: (OrderedCollection with: aSpaceship with: anotherSpaceship)
]

{ #category : #tests }
GameTest >> test022GameEndsAutomaticallyWhenSpaceshipPassesLastSquare [

	| aBoard aSpaceship aGame aLoadedDie someDice |
	aBoard := Board of: 8 wormholeBeginsAt: 1 andEndsAt: 2.
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	
	aLoadedDie := LoadedDie of: 10.
	someDice := OrderedCollection with: aLoadedDie.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: someDice
		         wonAfter: 1.
	aGame playTurn.

	self deny: aGame isOngoing
]

{ #category : #tests }
GameTest >> test023GameWithMultiplePlayersShowsLeaderBoard [

	| aGame aSpaceship anotherSpaceship yetAnotherSpaceship  aBoard aLoadedDie someDice leaderboard |
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	anotherSpaceship := Spaceship randomCardsLaunch:  ''.
	yetAnotherSpaceship := Spaceship randomCardsLaunch:  'Three'.
	
	aBoard := Board of: 10 wormholeBeginsAt: 5 andEndsAt: 6.
	aLoadedDie := LoadedDie arrayOf:
		              (OrderedCollection with: 3 with: 2 with: 1).
	someDice := OrderedCollection with: aLoadedDie.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship . yetAnotherSpaceship }
		         on: aBoard
		         throwing: someDice
		         wonAfter: 1.
	[ aGame isOngoing ] whileTrue: [ aGame playTurn ].
	leaderboard := aGame leaderBoard.
	self
		assert: leaderboard asOrderedCollection
		equals: (OrderedCollection
				 with: aSpaceship
				 with: anotherSpaceship
				 with: yetAnotherSpaceship)
]

{ #category : #tests }
GameTest >> test024GameStoresADie [

	| aGame aSpaceship aBoard aLoadedDie someDice |
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	aBoard := Board of: 10 wormholeBeginsAt: 1 andEndsAt: 2.
	aLoadedDie := LoadedDie of: 6.
	someDice := OrderedCollection with: aLoadedDie.
	aGame := Game
		         playedBy: {aSpaceship } 
		         on: aBoard
		         throwing: someDice
		         wonAfter: 1.
	aGame playTurn.
	self assert: ( aSpaceship position ) equals: 7
]

{ #category : #tests }
GameTest >> test025GameCanUseMultipleDice [

	| aGame aSpaceship  aBoard aLoadedDie anotherLoadedDie someDice |
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	aBoard := Board of: 12 wormholeBeginsAt: 1 andEndsAt: 2.
	aLoadedDie := LoadedDie of: 6.
	anotherLoadedDie := LoadedDie of: 4.
	someDice := OrderedCollection with: aLoadedDie with: anotherLoadedDie.
	aGame := Game
		         playedBy: {aSpaceship } 
		         on: aBoard
		         throwing: someDice
		         wonAfter: 1.
	aGame playTurn.
	self assert: ( aSpaceship position ) equals: 11
]

{ #category : #tests }
GameTest >> test031TurnCannotBePlayedIfGameIsOver [

	| aGame aSpaceship aDie aBoard |
	aSpaceship := Spaceship randomCardsLaunch:  'Millenium Falcon'.
	aBoard := Board of: 5 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie of: 5.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame playTurn.

	self
		should: [ aGame playTurn ]
		raise: Error
		withMessage: 'Game has already ended'
]

{ #category : #tests }
GameTest >> test036GameDoesNotHaveInformationOfSpaceshipsThatArentPlaying [

	| aGame aSpaceship anotherSpaceship aDie aBoard |
	aSpaceship := Spaceship randomCardsLaunch:  'Millenium Falcon'.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Death Star'.
	
	aDie := LoadedDie of: 5.
	aBoard := Board of: 12 wormholeBeginsAt: 1 andEndsAt: 2.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.

	self
		should: [ aGame dataFor: anotherSpaceship ]
		raise: Error
		withMessage: 'That spaceship is not a player in this game'
]

{ #category : #tests }
GameTest >> test39AfterSpaceshipPassesLastSquareForTheFirstTimeThenNumberOfLapsIsOne [

	| aGame aSpaceship aBoard aDie |	
	aBoard := Board of: 5 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie of: 8.
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.

	aGame playTurn.
	self assert: ( aSpaceship laps ) equals: 1
]

{ #category : #tests }
GameTest >> test40AfterSpaceshipCrossesTheFinishLineTwiceThenHasTwoLaps [

	| aGame aSpaceship aBoard aDie |
	
	aBoard := Board of: 5 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie of: 11.
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.

	aGame playTurn.
	self assert: (aSpaceship  laps ) equals: 2
]

{ #category : #tests }
GameTest >> test42ASpaceshipStartsWithThreeShields [

	| aGame aSpaceship aDie aBoard |
	
	aBoard := Board of: 4 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie of: 3.
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	self assert: (aSpaceship  shields ) equals: 3
]

{ #category : #tests }
GameTest >> test43AfterLosingABattleSpaceshipLosesAShield [

	| aGame aSpaceship anotherSpaceship aDie aBoard  |
	aSpaceship := Spaceship randomCardsLaunch:  'One'.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	
	aBoard := Board of: 4 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 1 with: 3).
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame battleBetween: aSpaceship and: anotherSpaceship.

	self assert: (aSpaceship shields) equals: 2
]

{ #category : #tests }
GameTest >> test44IfSpaceshipWinsBattleDoesntLoseShields [

	| aGame aSpaceship anotherSpaceship aDie aBoard |
	
	aBoard := Board of: 4 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 5 with: 3).
	aSpaceship := Spaceship randomCardsLaunch:  'One'.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame battleBetween: aSpaceship and: anotherSpaceship.

	self assert: (aSpaceship  shields ) equals: 3
]

{ #category : #tests }
GameTest >> test45SpaceshipLosesTwoBattlesAndLosesTwoShields [

	| aGame aSpaceship anotherSpaceship aDie aBoard |

	aBoard := Board of: 4 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 1 with: 3).
	aSpaceship := Spaceship randomCardsLaunch:  'One'.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame battleBetween: aSpaceship and: anotherSpaceship.
	aGame battleBetween: aSpaceship and: anotherSpaceship.

	self assert: (aSpaceship shields ) equals: 1
]

{ #category : #tests }
GameTest >> test46AfterLosingBattleSpaceshipGetsSentToBeginning [

	| aGame aSpaceship anotherSpaceship aDie aBoard |
	
	aBoard := Board of: 4 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie arrayOf:
		        (OrderedCollection with: 3 with: 3 with: 4).
	aSpaceship := Spaceship randomCardsLaunch:  'One'.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame playTurn.
	aGame battleBetween: aSpaceship and: anotherSpaceship.

	self assert: ( aSpaceship position ) equals: 1
]

{ #category : #tests }
GameTest >> test47WhenTwoSpaceshipsLandOnTheSameSquareTheyBattle [

	| aGame aSpaceship anotherSpaceship aDie aBoard |
	aBoard := Board of: 6 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie arrayOf:
		        (OrderedCollection with: 3 with: 3 with: 2).
	aSpaceship := Spaceship randomCardsLaunch: 'One'.
	anotherSpaceship := Spaceship randomCardsLaunch: 'Two'.
	aGame := Game
		         playedBy: {
				         aSpaceship.
				         anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame playTurn.
	aGame playTurn.

	self assert: anotherSpaceship position equals: 1
]

{ #category : #tests }
GameTest >> test48IfBattleEndsOnADrawThenLastSpaceshipToArriveLoses [

	| aGame aSpaceship anotherSpaceship aDie aBoard |
	
	aBoard := Board of: 6 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie of: 3.
	aSpaceship := Spaceship randomCardsLaunch:  'One'.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame playTurn.
	aGame playTurn.
	self assert: (( anotherSpaceship position) = 1 and:
			 ( aSpaceship position ) = 4)
]

{ #category : #tests }
GameTest >> test49SpaceshipCanSkipTurn [

	| aGame aSpaceship anotherSpaceship aDie aBoard |
	
	aBoard := Board of: 4 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie of: 3.
	aSpaceship := Spaceship randomCardsLaunch:  'One'.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame skipTurn.

	self assert: aGame nextSpaceshipToPlay equals: anotherSpaceship
]

{ #category : #tests }
GameTest >> test50SkippingATurnRechargesShields [

	| aGame aSpaceship anotherSpaceship aDie aBoard |
	
	aBoard := Board of: 4 wormholeBeginsAt: 1 andEndsAt: 2.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 1 with: 2).
	aSpaceship := Spaceship randomCardsLaunch:  'One'.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	aGame battleBetween: aSpaceship and: anotherSpaceship.
	aGame skipTurn.

	self assert: (aSpaceship shields ) equals: 3
]

{ #category : #tests }
GameTest >> test51FirstSquareIsASafeZone [

	| aGame aSpaceship anotherSpaceship aDie aBoard |
	
	aBoard := Board of: 4 wormholeBeginsAt: 2 andEndsAt: 3.
	aDie := LoadedDie of: 4.
	aSpaceship := Spaceship randomCardsLaunch:  'One'.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 3.
	aGame playTurn.
	aGame playTurn.
	self assert: (aSpaceship shields ) equals: 3
]

{ #category : #tests }
GameTest >> test52IfSpaceshipLosesAllShieldsThenTheirTurnGetsSkipped [

	| aGame aSpaceship anotherSpaceship aDie aBoard |
	
	aBoard := Board of: 4 wormholeBeginsAt: 2 andEndsAt: 3.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 2 with: 3).
	aSpaceship := Spaceship randomCardsLaunch:  'One'.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	3 timesRepeat: [
		aGame battleBetween: aSpaceship and: anotherSpaceship ].
	aGame playTurn.
	self assert: (aSpaceship position ) equals: 1
]

{ #category : #tests }
GameTest >> test53AfterLosingAllShieldsSpaceshipCannotPlayForTwoTurns [

	| aGame aSpaceship anotherSpaceship aDie aBoard |
	
	aBoard := Board of: 4 wormholeBeginsAt: 2 andEndsAt: 3.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 2 with: 3).
	aSpaceship := Spaceship randomCardsLaunch:  'One'.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	3 timesRepeat: [
		aGame battleBetween: aSpaceship and: anotherSpaceship ].
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	self assert: ( aSpaceship position ) equals: 1
]

{ #category : #tests }
GameTest >> test54AfterLosingTwoTurnsSpaceshipCanPlayAgain [

	| aGame aSpaceship anotherSpaceship aDie aBoard |
	
	aBoard := Board of: 8 wormholeBeginsAt: 6 andEndsAt: 7.
	aDie := LoadedDie arrayOf: (OrderedCollection with: 2 with: 3).
	aSpaceship := Spaceship randomCardsLaunch:  'One'.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	3 timesRepeat: [
		aGame battleBetween: aSpaceship and: anotherSpaceship ].
	5 timesRepeat: [ aGame playTurn ].

	self assert: ( aSpaceship position ) equals: 3
]

{ #category : #tests }
GameTest >> test66GameIsWonAfterOneLap [

	| aGame aSpaceship aBoard aDie aNumberOfLaps |
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	aBoard := self
		          createBoardOf: 3
		          distance: (ParsecDistance of: 1)
		          withEffects: (OrderedCollection new)
		          wormholeBeginsAt: 2
		          andEndsAt: 3.
	
	aDie := LoadedDie of: 3.
	aNumberOfLaps := 1.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: aNumberOfLaps.
	aGame playTurn.

	self assert: aGame winner equals: aSpaceship
]

{ #category : #tests }
GameTest >> test67GameIsWonAfterANumberOfLaps [

	| aGame aSpaceship aBoard aDie aNumberOfLaps |
	aSpaceship := Spaceship randomCardsLaunch:  ''.
	
	aBoard := self
		          createBoardOf: 3
		          distance: (ParsecDistance of: 1)
		          withEffects: (OrderedCollection new)
		          wormholeBeginsAt: 2
		          andEndsAt: 3.
	aDie := LoadedDie of: 3.
	aNumberOfLaps := 10.
	aGame := Game
		         playedBy: {aSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: aNumberOfLaps.
	aNumberOfLaps timesRepeat: [ aGame playTurn ].

	self assert: aGame winner equals: aSpaceship
]

{ #category : #tests }
GameTest >> test78FirstSquareIsASafeZone [

	| aGame aSpaceship anotherSpaceship aBoard aDie |
	
	aBoard := Board of: 10 wormholeBeginsAt: 1 andEndsAt: 3.
	aDie := LoadedDie of: 3.
	aSpaceship := Spaceship randomCardsLaunch:  'One'.
	anotherSpaceship := Spaceship randomCardsLaunch:  'Two'.
	aGame := Game
		         playedBy: {aSpaceship . anotherSpaceship }
		         on: aBoard
		         throwing: (OrderedCollection with: aDie)
		         wonAfter: 1.
	self assert: (aSpaceship shields  ) equals: 3
]
