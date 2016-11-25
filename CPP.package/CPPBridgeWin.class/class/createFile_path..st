as yet unclassified
createFile_path: aPathUnicode
	"create a file with shared read and write access and  if it exists it just opens it"

	| return |
	"HANDLE WINAPI CreateFile(
  _In_     LPCTSTR               lpFileName,
  _In_     DWORD                 dwDesiredAccess,
  _In_     DWORD                 dwShareMode,
  _In_opt_ LPSECURITY_ATTRIBUTES lpSecurityAttributes,
  _In_     DWORD                 dwCreationDisposition,
  _In_     DWORD                 dwFlagsAndAttributes,
  _In_opt_ HANDLE                hTemplateFile
);                 // name of mapping object"
	return := self ffiCall: #(void * CreateFileW #(String aPathUnicode , 3221225472 , 3 , 0 , 4 , 128 , 0)).
	return value = 0
		ifTrue: [ self error: 'Error mapping file to memory' ].
	^ return