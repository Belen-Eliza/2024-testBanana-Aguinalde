"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  Boom!

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #AtomicBombEffect,
	#superclass : #Object,
	#instVars : [
		'squareNumber'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #testing }
AtomicBombEffect class >> isIn: aPosition [

 ^self new initializeIsIn: aPosition 
]

{ #category : #action }
AtomicBombEffect >> applyIn: aGame for: aSpaceship [ 
	aGame detonateAtomicBomb .
	

]

{ #category : #action }
AtomicBombEffect >> applyInvertedIn: aGame for: aSpaceship [ 
	self applyIn: aGame  for: aSpaceship 
]

{ #category : #initialization }
AtomicBombEffect >> initializeIsIn: aPosition [ 

squareNumber := aPosition.
]

{ #category : #accessing }
AtomicBombEffect >> squareNumber [ 

^squareNumber 
]
