accessing structure variables
data
	"This method was automatically generated"
	^(FFITypeArray ofType: #FFICharacterType size: 3000) fromHandle: (handle copyFrom: 1 to: 3000)