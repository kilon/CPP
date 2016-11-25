file operations
closeHandle: aPointerToFileMapping
"closes handles, handles are used for many diffirent things in windows"
	| return |
	"BOOL WINAPI CloseHandle(
  _In_ HANDLE hObject
);
              "
	return := self ffiCall: #(bool CloseHandle #(void * aPointerToFileMapping)).
	return value = 0
		ifTrue: [ self error: 'Error mapping file to memory' ].
	^ return