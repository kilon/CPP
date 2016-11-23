// CPP.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <windows.h>
#include <stdio.h>
#include <conio.h>
#include <tchar.h>
#include <typeinfo>
#include <iostream>

#define BUF_SIZE 256
TCHAR szName[] = TEXT("m");
TCHAR szMsg[] = TEXT("m");
long  m2 = 'm';
char s = 'a';


int _tmain()
{
	HANDLE hMapFile;
	LPCTSTR pBuf;
	void * x;
	
	
	
	//CreateFileMappingA();
	hMapFile = CreateFileMapping(
		INVALID_HANDLE_VALUE,    // use paging file
		NULL,                    // default security
		PAGE_READWRITE,          // read/write access
		0,                       // maximum object size (high-order DWORD)
		BUF_SIZE,                // maximum object size (low-order DWORD)
		szName);                 // name of mapping object

	if (hMapFile == NULL)
	{
		_tprintf(TEXT("Could not create file mapping object (%d).\n"),
			GetLastError());
	
		return 1;
	}
	pBuf = (LPTSTR)MapViewOfFile(hMapFile,   // handle to map object
		FILE_MAP_ALL_ACCESS, // read/write permission
		0,
		0,
		BUF_SIZE);

	if (pBuf == NULL)
	{
		_tprintf(TEXT("Could not map view of file (%d).\n"),
			GetLastError());

		CloseHandle(hMapFile);

		return 1;
	}
	CopyMemory((PVOID)pBuf, szMsg, (_tcslen(szMsg) * sizeof(TCHAR)));

	std::cout << "size of TCHAR :" << sizeof(TCHAR) << "\n";

	std::cout << "size of void * : " << sizeof(x) << "\n";
	std::cout << "value of s : " << int(s) << "\n";
	std::cout << "size of int : " << sizeof(int) << "\n";
	std::cout << "size of unsigned long : " << sizeof(unsigned long) << "\n";

	std::cout << "\n********************************** \n\n";
	std::cout << "(type | size | value ) of INVALID_HANDLE_VALUE : (" << typeid(INVALID_HANDLE_VALUE).name()
		<< " | " << sizeof(INVALID_HANDLE_VALUE) << " | " << INVALID_HANDLE_VALUE << ")\n"

		<< "(type | size | value ) of hMapFile : (" << typeid(hMapFile).name()
		<< " | " << sizeof(hMapFile) << " | " << hMapFile << ")\n"

		<< "(type | size | value ) of NULL : (" << typeid(NULL).name()
		<< " | " << sizeof(NULL) << " | " << NULL << ")\n"

		<< "(type | size | value ) of PAGE_READWRITE : (" << typeid(PAGE_READWRITE).name()
		<< " | " << sizeof(PAGE_READWRITE) << " | " << PAGE_READWRITE << ")\n"

		<< "(type | size | value ) of FILE_MAP_ALL_ACCESS : (" << typeid(FILE_MAP_ALL_ACCESS).name()
		<< " | " << sizeof(FILE_MAP_ALL_ACCESS) << " | " << FILE_MAP_ALL_ACCESS << ")\n"

		<< "(type | size | value ) of szName : (" << typeid(szName).name()
		<< " | " << sizeof(szName) << " | " << szName << ")\n"
		
		<< "(type | size | value ) of m2 : (" << typeid(m2).name()
		<< " | " << sizeof(m2) << " | " << szName << ")\n";;
	
	std::cout << "\nvalue of szName reference : " << "[";

	for (int i = 0; i < sizeof(szName) / 2; ++i)
	{
		std::cout << " " << szName[i];
	}
	
	std::cout<<"]\n\n*****************************\n";

	std::cout << "\n\n\nLooks like everything went ok :) " << "\n";
	
	_getch();

	

	UnmapViewOfFile(pBuf);

	CloseHandle(hMapFile);

	return 0;
}


