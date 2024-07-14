"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  When played, target spaceship becomes a merecenary

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	ally:		<Object>
	mercenary:		<Object>


    Implementation Points
"
Class {
	#name : #MercenaryCard,
	#superclass : #PermanentCard,
	#instVars : [
		'ally',
		'mercenary'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #action }
MercenaryCard >> from: aSpaceship targeting: anotherSpaceship useIn: aGame [
	self validateIfCardCanBePlayedBy: aSpaceship in: aGame.
	self validateAllianceBetween: aSpaceship and: anotherSpaceship .
	aGame validateMercenaryAvailability: anotherSpaceship .
	mercenary:=anotherSpaceship.
	ally := aSpaceship.
	aGame addActiveCard: self.
	^self
]

{ #category : #accessing }
MercenaryCard >> is: aSpaceship anAllyOf: anotherSpaceship [

^((aSpaceship = ally) and: anotherSpaceship = mercenary) or: ((aSpaceship = mercenary ) and: anotherSpaceship = ally)
]

{ #category : #accessing }
MercenaryCard >> mercenary [
^mercenary
]

{ #category : #action }
MercenaryCard >> reduceShieldsOfAllyOf: aSpaceship in: aGame [

aSpaceship =ally ifTrue: [ aGame decreaseShieldByOneOf:  mercenary. ].
]

{ #category : #action }
MercenaryCard >> reinforce: aSpaceship using: aDiceBeaker [

	aSpaceship = ally ifTrue: [ ^ aDiceBeaker throwDice ].
	^ 0
]

{ #category : #validation }
MercenaryCard >> validateAllianceBetween: aSpaceship and: anotherSpaceship [
	aSpaceship = anotherSpaceship ifTrue: [ Error signal: 'A spaceship cannot be its own mercenary' ]
]
