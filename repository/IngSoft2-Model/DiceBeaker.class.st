"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  A small, clinidrical container for throwing dice

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	dice:		<Object>


    Implementation Points
"
Class {
	#name : #DiceBeaker,
	#superclass : #Object,
	#instVars : [
		'dice'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #building }
DiceBeaker class >> fillWith: someDice [
	^self new initializeFillWith: someDice 
]

{ #category : #initialization }
DiceBeaker >> initializeFillWith: someDice [ 

	dice := OrderedCollection withAll: someDice 
]

{ #category : #action }
DiceBeaker >> throwDice [

	|result|
	result :=0.
	dice do: [ :aDie | result := result + aDie throw ].
 	^ result 
]
