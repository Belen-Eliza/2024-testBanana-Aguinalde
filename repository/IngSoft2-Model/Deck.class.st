"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part: A deck of cards

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	cards:		<Object>


    Implementation Points
"
Class {
	#name : #Deck,
	#superclass : #Object,
	#instVars : [
		'cards'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Deck class >> createWith: someCards [ 
	^self new initializeCreateWith: someCards .
]

{ #category : #'instance creation' }
Deck class >> createWithRandomCards [
	^self new initializeCreateWithRandomCards
]

{ #category : #adding }
Deck >> addRandomCard [

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

{ #category : #accessing }
Deck >> cards [
	^ cards
]

{ #category : #removing }
Deck >> discardRandomCard [
	cards ifNotEmpty: [ cards remove:  (cards atRandom)  ]
	

]

{ #category : #testing }
Deck >> includes: aCard [ 
	^cards includes: aCard 
]

{ #category : #initialization }
Deck >> initializeCreateWith: someCards [ 
	cards:= OrderedCollection withAll:  someCards 
]

{ #category : #initialization }
Deck >> initializeCreateWithRandomCards [
	
	cards:= OrderedCollection new.
	2 timesRepeat: [ self addRandomCard].
]

{ #category : #removing }
Deck >> remove: aCard [ 
	cards remove:  aCard 
]
