file operations
openFile: aString flags: flags
"opens a file to be used for mapping the shared memory"
|return|
return:=self ffiCall: #( int open(String aString ,int flags)).
return = -1 ifTrue:[self error:'Error opening file'].
^return