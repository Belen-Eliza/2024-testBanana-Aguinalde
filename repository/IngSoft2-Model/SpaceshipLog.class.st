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
		'positionTracker',
		'deck'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
SpaceshipLog class >> for: aSpaceship with: aDeck trackingPositionWith: aPositionTracker [

	^self new initializeFor: aSpaceship  with: aDeck  trackingPositionWith: aPositionTracker 
]

{ #category : #comparing }
SpaceshipLog >> >= anotherSpaceship [

	self laps = anotherSpaceship laps
		ifFalse: [ ^ self laps >= anotherSpaceship laps ]
		ifTrue: [ ^ self position >= anotherSpaceship position ]
		

		
]

{ #category : #adding }
SpaceshipLog >> addRandomCard [
	deck addRandomCard 
]

{ #category : #accessing }
SpaceshipLog >> cards [
^deck cards 
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

{ #category : #adding }
SpaceshipLog >> increaseShieldsByOne [

	shields := shields +1
]

{ #category : #initialization }
SpaceshipLog >> initializeFor: aSpaceship with: aDeck trackingPositionWith: aPositionTracker [

	spaceship := aSpaceship .
	state := NoPenaltyState new.
	shields := 3.
	deck:= aDeck .
	positionTracker := aPositionTracker 
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
SpaceshipLog >> removeFromHand: aCard [

 deck remove: (aCard class)
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
SpaceshipLog >> validateThatSpaceshipHas: aCard [
	
	(deck includes: aCard class) ifFalse: [
		Error signal:
			'A Spaceship cannot play a card that is not in its hand' ]
]
