"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  Designate a spaceship as a protector of the spaceship that played the card

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	protected:		<Object>
	protector:		<Object>


    Implementation Points
"
Class {
	#name : #ProtectorCard,
	#superclass : #PermanentCard,
	#instVars : [
		'protector',
		'protected'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #action }
ProtectorCard >> from: aSpaceship targeting: anotherSpaceship useIn: aGame [ 
	self validateIfCardCanBePlayedBy: aSpaceship in: aGame.
	protector:= anotherSpaceship .
	protected := aSpaceship .
	aGame addActiveCard: self.
	^self
]

{ #category : #accessing }
ProtectorCard >> protected [
	^ protected
]

{ #category : #accessing }
ProtectorCard >> protector [
	^ protector
]

{ #category : #action }
ProtectorCard >> reduceShieldsOfAllyOf: aSpaceship in: aGame [

aSpaceship =protected  ifTrue: [ aGame decreaseShieldByOneOf:  protector ].
]
