"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part: Inverts the effect in a given square

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
	#name : #ReversalCard,
	#superclass : #PermanentCard,
	#instVars : [
		'effect'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #accessing }
ReversalCard >> effect [
	^ effect
]

{ #category : #action }
ReversalCard >> from: aSpaceship targeting: anEffect useIn: aGame [
	self validateIfCardCanBePlayedBy: aSpaceship  in: aGame .
	aGame addActiveCard: self.
	effect:= anEffect .
	^self
]
