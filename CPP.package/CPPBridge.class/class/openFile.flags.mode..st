file operations
openFile: aString flags: oneOrMoreFlags mode: aFileMode
"opens a file to be used for mapping the shared memory"
|return|
return:=self ffiCall: #( int open(String aString ,int  oneOrMoreFlags , int aFileMode)).
return = -1 ifTrue:[self error:'Error opening file'].
^return