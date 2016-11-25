string handling
generateUnicodeFromString: aString
|result|
result := ''.
aString do:[:each| result:= result ,each asString,(Character null asString)].
^result  