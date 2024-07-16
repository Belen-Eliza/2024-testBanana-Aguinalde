Class {
	#name : #Game,
	#superclass : #Object,
	#instVars : [
		'spaceships',
		'board',
		'state',
		'spaceshipsData',
		'laps',
		'activeCards',
		'lastTypeOfCardPlayed',
		'lastEffectTriggered',
		'diceBeaker'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #initialization }
Game class >> playedBy: someSpaceships on: aBoard throwing: someDice wonAfter: aNumberOfLaps [ 
	^self new initializePlayedBy: someSpaceships  on: aBoard  throwing: someDice wonAfter: aNumberOfLaps .
]

{ #category : #adding }
Game >> addActiveCard: aCard [

lastTypeOfCardPlayed := aCard class.
activeCards add: aCard.

]

{ #category : #adding }
Game >> addRandomCardFor: aSpaceship [

(self dataFor: aSpaceship) addRandomCard.
]

{ #category : #action }
Game >> applyHyperSpaceJumpFor: aSpaceship [ 

	self  decreaseShieldByOneOf: aSpaceship.
	(self dataFor: aSpaceship ) move: 4.
	
]

{ #category : #action }
Game >> applyInvertedHyperSpaceJumpFor: aSpaceship [ 

	self  increaseShieldsByOneOf:  aSpaceship.
	(self dataFor: aSpaceship ) move: -4.
	
]

{ #category : #action }
Game >> applyInvertedWormholeFor: aSpaceship goingFrom: squareNumber to: otherSide [

	(self dataFor: aSpaceship) move:
		(board distanceBetween: squareNumber and: otherSide)
]

{ #category : #action }
Game >> battleBetween: aSpaceship and: aSpaceship2 [

	| loser resultForFirstPlayer resultForSecondPlayer |
	resultForFirstPlayer := diceBeaker throwDice.
	resultForFirstPlayer := resultForFirstPlayer + (activeCards inject: 0 into: [ :accumulator :card | accumulator + (card reinforce: aSpaceship  using: diceBeaker )]).

	resultForSecondPlayer := diceBeaker throwDice.
	resultForSecondPlayer := resultForSecondPlayer + (activeCards inject: 0 into: [ :accumulator :card | accumulator + (card reinforce: aSpaceship2 using: diceBeaker )]).

	loser := resultForFirstPlayer > resultForSecondPlayer
		         ifTrue: [ aSpaceship2 ]
		         ifFalse: [ aSpaceship ].
	self reducePartyShieldsByOneOf: loser
]

{ #category : #action }
Game >> battleIn: position [

	| aSpaceship |
	aSpaceship := self nextSpaceshipToPlay.

	spaceships allButFirstDo: [ :spaceship |
		((self is: spaceship in: position) and:
			 (self is: spaceship notAnAllyOf: aSpaceship)) ifTrue: [
			self battleBetween: aSpaceship and: spaceship ] ]
]

{ #category : #action }
Game >> calculateFinalPositionFor: aSpaceship [

	| diceResult newPosition cardModifier |
	diceResult := diceBeaker throwDice.

	cardModifier := activeCards inject: 0  into: [:accumulator :card | accumulator + (card playOn: aSpaceship) ].
	diceResult := diceResult + cardModifier.

	(self dataFor: aSpaceship) move: diceResult.
	newPosition := aSpaceship position .

	board
		applyEffectFor: aSpaceship
		afterMovingTo: newPosition
		whenPlaying: self
]

{ #category : #action }
Game >> changeStateOf: aSpaceship to: aState [

	(self dataFor: aSpaceship ) changeStateTo: aState 
]

{ #category : #action }
Game >> checkForWinner [

	(spaceshipsData anySatisfy: [ :dataForASpaceship |
		 dataForASpaceship laps >= laps ]) ifTrue: [ self end ]
]

{ #category : #converting }
Game >> convertToSquares: aParsecDistance [
	^board convertToSquares: aParsecDistance
	
]

{ #category : #accessing }
Game >> dataFor: aSpaceship [

	^ spaceshipsData
		  detect: [ :dataForASpaceship |
		  dataForASpaceship spaceship = aSpaceship ]
		  ifNone: [
		  Error signal: 'That spaceship is not a player in this game' ]
]

{ #category : #adding }
Game >> decreaseAllShieldsByOne [

	spaceshipsData do: [ :dataForASpaceship |
		dataForASpaceship decreaseShieldsByOne ]
]

{ #category : #adding }
Game >> decreaseShieldByOneOf: aSpaceship [

	(self dataFor: aSpaceship) decreaseShieldsByOne  
]

{ #category : #action }
Game >> detonateAtomicBomb [
	self moveAllBackToBeginning .
	self decreaseAllShieldsByOne .
]

{ #category : #action }
Game >> discardACardFor: aSpaceship [ 
	(self dataFor: aSpaceship ) discardACard 
]

{ #category : #adding }
Game >> end [
	state := GameFinishedState new.
]

{ #category : #action }
Game >> increaseShieldsByOneOf: aSpaceship [ 

	(self dataFor: aSpaceship ) increaseShieldsByOne
]

{ #category : #initialization }
Game >> initializePlayedBy: someSpaceships on: aBoard throwing: someDice wonAfter: aNumberOfLaps [ 

spaceships := OrderedCollection withAll:  someSpaceships.
board := aBoard.
self initializeSpaceships.
state := GameOngoingState new.

diceBeaker := DiceBeaker fillWith: someDice.
laps := aNumberOfLaps .
activeCards:= OrderedCollection new.
lastEffectTriggered:= NullEffect new.
]

{ #category : #initialization }
Game >> initializeSpaceships [

	| numberOfPlayers dataForASpaceship|
	numberOfPlayers := spaceships size.

	spaceshipsData := OrderedCollection new.
	spaceships do: [ :aSpaceship |
		dataForASpaceship :=SpaceshipLog
				 for: aSpaceship
				 with: aSpaceship starterDeck
				 trackingPositionWith: (PositionTracker beginIn: board).
		spaceshipsData add: dataForASpaceship .
		aSpaceship keepARecordWith: (dataForASpaceship ) ]
]

{ #category : #action }
Game >> is: spaceship in: position [

	^  spaceship position  = position
]

{ #category : #action }
Game >> is: spaceship notAnAllyOf: aSpaceship [

	^ activeCards allSatisfy: [ :card |
		  (card is: aSpaceship anAllyOf: spaceship) not ]
]

{ #category : #testing }
Game >> isInverted: anEffect [

	^ activeCards anySatisfy: [ :card | card effect = anEffect ]
]

{ #category : #accessing }
Game >> isOngoing [

^ state isOngoing.
]

{ #category : #accessing }
Game >> leaderBoard [

	^ spaceships asSortedCollection: [ :sp1 :sp2 |
		  (self dataFor: sp1) >= (self dataFor: sp2) ]
]

{ #category : #action }
Game >> make: aSpaceship move: someSquares [

	(self dataFor: aSpaceship) move:  someSquares 

]

{ #category : #action }
Game >> makeAllBut: aSpaceship move: someSquares [

	| selectedSpaceships |
	selectedSpaceships:= spaceships select:[ :spaceship | spaceship ~= aSpaceship .].
	selectedSpaceships do: [ :spaceship |
		(self dataFor: spaceship) move:  someSquares  
		 ]
]

{ #category : #action }
Game >> move: aSpaceship to: aPosition [ 

	(self dataFor: aSpaceship) moveTo: aPosition  .

]

{ #category : #action }
Game >> moveAllBackToBeginning [
	
	spaceshipsData do: [ :dataForASpaceship | dataForASpaceship moveTo: 1 ]
]

{ #category : #accessing }
Game >> nextSpaceshipToPlay [
	^ spaceships first.
]

{ #category : #adding }
Game >> nextTurn [

	|aSpaceship|
	aSpaceship := spaceships removeFirst.
	spaceships addLast: aSpaceship.
	
]

{ #category : #action }
Game >> play: aCard from: aSpaceship targeting: anotherSpaceship [
	|card|
	self validateIf: aCard  canBePlayedBy: aSpaceship .
	card := aCard from: aSpaceship targeting: anotherSpaceship useIn: self.
	(self dataFor: aSpaceship) removeFromHand: aCard. 
	^card 
	
]

{ #category : #action }
Game >> playTurn [
 
	| aSpaceship |
	state validateTurn.
	aSpaceship := self nextSpaceshipToPlay.
	(self dataFor: aSpaceship ) playIn: self.

	self nextTurn
]

{ #category : #accessing }
Game >> players [
^ spaceships.
]

{ #category : #adding }
Game >> rechargeShieldsOf: aSpaceship [
	(self dataFor: aSpaceship ) rechargeShields
]

{ #category : #action }
Game >> redoLastCardPlayedFor: aSpaceship targeting: aTarget [
	| aCard |
	self validateLastCardPlayed.
	state validateStateForCards.

	aCard:= lastTypeOfCardPlayed new.
	^ aCard from: aSpaceship targeting: aTarget  useIn: self.
]

{ #category : #action }
Game >> reducePartyShieldsByOneOf: loser [
	
	activeCards  do: [ :card | card reduceShieldsOfAllyOf: loser in: self ].
	(self dataFor: loser) decreaseShieldsByOne . 
	(self dataFor: loser) moveTo: 1
	
]

{ #category : #removing }
Game >> removeActiveCard: aCard [ 
	
	activeCards remove: aCard ifAbsent: [ Error signal: 'Selected card is not active'. ].
	lastTypeOfCardPlayed := CancellationCard .
]

{ #category : #action }
Game >> repeatLastEffectFor: aSpaceship [ 

	lastEffectTriggered applyIn: self for: aSpaceship.	
	lastTypeOfCardPlayed := RepeatCard .
	
	

]

{ #category : #adding }
Game >> saveLastEffectTriggeredTo: anEffect [

lastEffectTriggered := anEffect deepCopy .
]

{ #category : #action }
Game >> skipTurn [
	|aSpaceship|
	aSpaceship := self nextSpaceshipToPlay .
	self rechargeShieldsOf: aSpaceship.
	self nextTurn.
	
]

{ #category : #action }
Game >> turn [

	| aSpaceship position |
	aSpaceship := self nextSpaceshipToPlay .
	self calculateFinalPositionFor: aSpaceship.
	position := aSpaceship position .
	position = 1 ifFalse: [ self battleIn: position ]. 
	self checkForWinner.
]

{ #category : #validation }
Game >> validateIf: aCard canBePlayedBy: aSpaceship [

	| spaceshipData |
	state validateStateForCards.
	
	spaceshipData := self dataFor: aSpaceship.
	spaceshipData validateThatSpaceshipHas: aCard .
]

{ #category : #validation }
Game >> validateLastCardPlayed [
	lastTypeOfCardPlayed ifNil: [Error signal: 'There are no cards played to redo'.]
]

{ #category : #validation }
Game >> validateMercenaryAvailability: aSpaceship [

	(activeCards anySatisfy: [ :card |
		 card mercenary = aSpaceship ]) ifTrue: [
		Error signal: 'Selected spaceship is already a mercenary' ]
]

{ #category : #accessing }
Game >> winner [

	^ state winnerOf: spaceshipsData after: laps 
]
