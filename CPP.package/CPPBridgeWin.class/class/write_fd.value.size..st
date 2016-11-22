memory operations
write_fd: aFd value: aString size: anInteger
"write a string to a file"

^ self ffiCall: #( int write ( int aFd , String aString , int anInteger )).
