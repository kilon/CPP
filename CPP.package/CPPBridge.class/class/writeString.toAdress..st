memory operations
writeString:aString toAdress: mmapPointer
"write a string to a specific point of the 
shared memory"

^ 1 to:(aString size) do:[:count| mmapPointer getHandle unsignedCharAt: count  put:( aString  at: count) ]
