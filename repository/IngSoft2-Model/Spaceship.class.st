Class {
	#name : #Spaceship,
	#superclass : #Object,
	#instVars : [
		'myName',
		'starterDeck',
		'log'
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

{ #category : #accessing }
Spaceship >> cards [ 
^log cards 
]

{ #category : #accessing }
Spaceship >> getName [
^ myName.
]

{ #category : #initialization }
Spaceship >> initializeLaunch: aName with: someCards [

myName := aName .
starterDeck := Deck createWith: someCards 
]

{ #category : #initialization }
Spaceship >> initializeRandomCardsLaunch: aName [ 

myName := aName .
starterDeck := Deck createWithRandomCards .
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

{ #category : #accessing }
Spaceship >> starterDeck [

	^starterDeck 
]
