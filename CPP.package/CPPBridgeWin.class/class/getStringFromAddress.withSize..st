memory operations
getStringFromAddress: aMmapPointer withSize: aSizeInBytes
"one byte per character also string terminates at first
zero byte"

^ (aMmapPointer  getHandle copyFrom: 1 to:3000 )asString.
