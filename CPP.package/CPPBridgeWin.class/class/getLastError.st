error handling
getLastError
	"It returns the last error for any action supporting this"

	| return |
	"
DWORD WINAPI GetLastError(void);"
	return := self ffiCall: #(unsignedLong GetLastError #()).
	return value = 0
		ifTrue: [ self error: 'Error mapping file to memory' ].
	^ return