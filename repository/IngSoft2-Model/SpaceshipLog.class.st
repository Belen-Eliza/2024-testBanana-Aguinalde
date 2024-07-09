"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  Data for a spaceship

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	laps:		<Object>
	position:		<Object>
	shields:		<Object>
	spaceship:		<Object>


    Implementation Points
"
Class {
	#name : #SpaceshipLog,
	#superclass : #Object,
	#instVars : [
		'spaceship',
		'shields',
		'state',
		'cards',
		'positionTracker'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
SpaceshipLog class >> for: aSpaceship withDeck: someCards [

	^self new initializeFor: aSpaceship withDeck: someCards
]

{ #category : #'instance creation' }
SpaceshipLog class >> randomCardsfor: aSpaceship [

	^self new initializeRandomCardsFor: aSpaceship
]

{ #category : #comparing }
SpaceshipLog >> = anotherSpaceship [

	
	^positionTracker = anotherSpaceship position 
]

{ #category : #comparing }
SpaceshipLog >> >= anotherSpaceship [

	self laps = anotherSpaceship laps
		ifFalse: [ ^ self laps >= anotherSpaceship laps ]
		ifTrue: [ ^ self position >= anotherSpaceship position ]
		

		
]

{ #category : #adding }
SpaceshipLog >> addRandomCard [

	| cardTypes randomCard |
	cardTypes := OrderedCollection
		             with: AccelerationCard
		             with: SpeedCard
		             with: MercenaryCard
		             with: RedoCard
		             with: RepeatCard.
		randomCard := cardTypes atRandom.
		cards add: randomCard new.
]

{ #category : #adding }
SpaceshipLog >> addToDeck: aCard [

cards add: aCard .
]

{ #category : #accessing }
SpaceshipLog >> cards [
^cards 
]

{ #category : #accessing }
SpaceshipLog >> changeStateTo: aState [ 

state := aState 
]

{ #category : #adding }
SpaceshipLog >> decreaseShieldsByOne [ 
	shields := shields -1 max: 0.
	shields = 0 ifTrue: [ state := Turn1RechargeState new  ].
]

{ #category : #comparing }
SpaceshipLog >> hash [ 

^shields hash + positionTracker hash + spaceship hash 
]

{ #category : #initialization }
SpaceshipLog >> initializeFor: aSpaceship withDeck: someCards [

	spaceship := aSpaceship .
	state := NoPenaltyState new.
	shields := 3.
	cards:= OrderedCollection withAll:  someCards.
]

{ #category : #initialization }
SpaceshipLog >> initializeRandomCardsFor: aSpaceship [

	spaceship := aSpaceship .
	state := NoPenaltyState new.
	shields := 3.
	cards:= OrderedCollection new.
	2 timesRepeat: [ self addRandomCard].
]

{ #category : #accessing }
SpaceshipLog >> keepTrackOfPositionWith: newPositionTracker [

	positionTracker := newPositionTracker
]

{ #category : #accessing }
SpaceshipLog >> laps [
^positionTracker laps  
]

{ #category : #accessing }
SpaceshipLog >> move: someSquares [

positionTracker move: someSquares 
]

{ #category : #accessing }
SpaceshipLog >> moveTo: aPosition [

	positionTracker moveTo:  aPosition 
]

{ #category : #action }
SpaceshipLog >> playIn: aGame [

	state playIn: aGame 
]

{ #category : #accessing }
SpaceshipLog >> position [
^positionTracker square
]

{ #category : #adding }
SpaceshipLog >> rechargeShields [

	shields := 3
]

{ #category : #removing }
SpaceshipLog >> removeCardFromHand: aCard [

 cards remove: (aCard class)
]

{ #category : #accessing }
SpaceshipLog >> shields [
^shields 
]

{ #category : #accessing }
SpaceshipLog >> spaceship [
^spaceship 
]

{ #category : #validation }
SpaceshipLog >> validateThatSpaceshipHasCard: aCard [
	
	(cards includes: aCard class) ifFalse: [
		Error signal:
			'A Spaceship cannot play a card that is not in its hand' ]
]
