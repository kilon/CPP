initialisation
initialize
	" set here the default values for the flags used by open() and mmap"

	ExampleDATA := {0}.	"Data used by example methods"
	INVALID_HANDLE_VALUE := ExternalAddress fromAddress: 16rFFFFFFFF.	"use this if you dont want to open or create a file for mapping"
	PAGE_READWRITE := 4.
	FILE_MAP_ALL_ACCESS := 983071.