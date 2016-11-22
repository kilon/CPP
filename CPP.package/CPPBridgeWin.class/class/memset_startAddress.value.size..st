memory operations
memset_startAddress: aStartAddress value: aNumber size: anInteger
"store a set of values to a range of shared memory"

^ self ffiCall: #( void * memset ( void * aStartAddress, int aNumber , int anInteger )).
