Class {
	#name : #Spaceship,
	#superclass : #Object,
	#instVars : [
		'myName',
		'log',
		'deck'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Spaceship class >> launch: aName with: someCards [

	^self new initializeLaunch: aName with: someCards
]

{ #category : #'instance creation' }
Spaceship class >> randomCardsLaunch: aName [ 

	^self new initializeRandomCardsLaunch: aName 
]

{ #category : #testing }
Spaceship >> canProtect [
 ^log canProtect 
]

{ #category : #accessing }
Spaceship >> cards [ 
^deck  cards 
]

{ #category : #accessing }
Spaceship >> deck [

	^deck 
]

{ #category : #accessing }
Spaceship >> getName [
^ myName.
]

{ #category : #initialization }
Spaceship >> initializeLaunch: aName with: someCards [

myName := aName .
deck := Deck createWith: someCards 
]

{ #category : #initialization }
Spaceship >> initializeRandomCardsLaunch: aName [ 

myName := aName .
deck := Deck createWithRandomCards .
]

{ #category : #setter }
Spaceship >> keepARecordWith: aSpaceshipLog [

	log
		ifNotNil: [
			Error signal:
				'Spaceship log cannot be changed in the middle of the game' ]
		ifNil: [ log := aSpaceshipLog ]
]

{ #category : #accessing }
Spaceship >> laps [ 

	^log laps 
]

{ #category : #accessing }
Spaceship >> position [ 

^log position 
]

{ #category : #accessing }
Spaceship >> shields [ 

	^log shields 
]

{ #category : #validation }
Spaceship >> validateThatMyDeckHas: aCard [
	
	(deck includes: aCard class) ifFalse: [
		Error signal:
			'A Spaceship cannot play a card that is not in its hand' ]
]
