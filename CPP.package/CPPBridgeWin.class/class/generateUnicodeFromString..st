string handling
generateUnicodeFromString: aString
"pharo unicode strings are incompatible with windows, this method create a windows unicode string of two bytes per unicode character "
	| result |
	result := ''.
	aString do: [ :each | result := result , each asString , Character null asString ].
	^ result