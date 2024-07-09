"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  Represents a distance calculated in lightyears

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.

    Instance Variables
	travelDistance:		<Object>


    Implementation Points
"
Class {
	#name : #LightyearDistance,
	#superclass : #Object,
	#instVars : [
		'travelDistance'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
LightyearDistance class >> of: aDistance [

	^ self new initializeOf: aDistance
]

{ #category : #action }
LightyearDistance >> inParsecs [
^travelDistance //3
]

{ #category : #initialization }
LightyearDistance >> initializeOf: aDistance [

travelDistance := aDistance.

]
