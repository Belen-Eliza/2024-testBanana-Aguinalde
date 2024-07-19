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
SpaceshipLog >> >= anotherSpaceshipLog [

	self laps = anotherSpaceshipLog laps
		ifFalse: [ ^ self laps >= anotherSpaceshipLog laps ]
		ifTrue: [ ^ self position >= anotherSpaceshipLog position ]
		

		
]

{ #category : #'add/remove' }
SpaceshipLog >> addRandomCard [
	deck addRandomCard 
]

{ #category : #accessing }
SpaceshipLog >> canProtect [
^state canProtect 
]

{ #category : #accessing }
SpaceshipLog >> changeStateTo: aState [ 

state := aState 
]

{ #category : #'add/remove' }
SpaceshipLog >> decreaseShieldsByOne [

	shields := shields - 1 max: 0.
	shields = 0 ifTrue:  [ self penalize ].
	
]

{ #category : #'add/remove' }
SpaceshipLog >> discardACard [
	deck discardRandomCard 
]

{ #category : #comparing }
SpaceshipLog >> hash [ 

^shields hash + positionTracker hash + spaceship hash 
]

{ #category : #'add/remove' }
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
SpaceshipLog >> laps [
^positionTracker laps  
]

{ #category : #moving }
SpaceshipLog >> move: someSquares [

positionTracker move: someSquares 
]

{ #category : #moving }
SpaceshipLog >> moveTo: aPosition [

	positionTracker moveTo:  aPosition 
]

{ #category : #action }
SpaceshipLog >> penalize [	
	state := Turn1RechargeState new.
	self moveTo: 1
]

{ #category : #action }
SpaceshipLog >> playIn: aGame [

	state playIn: aGame 
]

{ #category : #accessing }
SpaceshipLog >> position [
^positionTracker square
]

{ #category : #'add/remove' }
SpaceshipLog >> rechargeShields [

	shields := 3
]

{ #category : #'add/remove' }
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
