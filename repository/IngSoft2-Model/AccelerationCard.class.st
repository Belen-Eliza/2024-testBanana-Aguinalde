"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  When played, increases everyone's dice throw by one

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
	#name : #AccelerationCard,
	#superclass : #PermanentCard,
	#category : #'IngSoft2-Model'
}

{ #category : #action }
AccelerationCard >> from: aSpaceship targeting: anotherSpaceship useIn: aGame [
	self validateIfCardCanBePlayedBy: aSpaceship in: aGame.
	aGame addActiveCard: self.
	^self
]

{ #category : #playing }
AccelerationCard >> playOn: aSpaceship [

^1
]
