as yet unclassified
pointTo:aHandle
"this is used to pass the pointer returned to mmap so our Structure points to the Shared Memory. If you dont use this expect crashes. "
^((self new) setHandle: aHandle )initializeArray.
