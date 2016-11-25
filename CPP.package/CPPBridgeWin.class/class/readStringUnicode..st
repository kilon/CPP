examples
readStringUnicode: mmapPointer
	| aUnicodeString charIndex endReached |
	aUnicodeString  := ''.
	endReached := false.
	charIndex := 1.
	[ endReached ]
		whileFalse: [ (mmapPointer getHandle unsignedCharAt: charIndex) = Character null
				ifTrue: [ (mmapPointer getHandle unsignedCharAt: charIndex + 1) = Character null
						ifTrue: [ endReached := true ]
						ifFalse: [ charIndex := charIndex + 1 ] ]
				ifFalse: [ aUnicodeString  := aUnicodeString  , (mmapPointer getHandle unsignedCharAt: charIndex) asString.
					charIndex := charIndex + 1 ] ].
	^ aUnicodeString 