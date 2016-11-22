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
TCHAR szName[] = TEXT("MyFileMappingObject");
TCHAR szMsg[] = TEXT("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz");


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
	_tprintf(TEXT("size of TCHAR : %d \n"), sizeof(TCHAR));
	_tprintf(TEXT("size of char : %d\n"), sizeof(char));
	_tprintf(TEXT("size of pBuf : %d\n"), sizeof(pBuf));
	_tprintf(TEXT("size of void * : %d\n"), sizeof(x));
	_tprintf(TEXT("size of hMapFile : %d\n"), sizeof(hMapFile));
	_tprintf(TEXT("size of INVALID_HANDLE_VALUE : %d\n"), sizeof(INVALID_HANDLE_VALUE));
	//_tprintf(TEXT("size of INVALID_HANDLE_VALUE value : %d\n"), INVALID_HANDLE_VALUE);
	std::cout<<"type of INVALID_HANDLE_VALUE : " << typeid(INVALID_HANDLE_VALUE).name() <<"\n";
	std::cout << "value of INVALID_HANDLE_VALUE : " << INVALID_HANDLE_VALUE << "\n";
	_tprintf(TEXT("size of NULL : %d\n"), sizeof( NULL ));
	_tprintf(TEXT("size of PAGE_READWRITE : %d\n"), sizeof(PAGE_READONLY));
	std::cout << "value of PAGE_READWRITE : " << PAGE_READONLY << "\n";
	std::cout << "type of PAGE_READWRITE : " << typeid(PAGE_READWRITE).name() << "\n";
	std::cout << "type of szName : " << typeid(szName).name() << "\n";
	_tprintf(TEXT("size of int : %d\n"), sizeof(int));
	_tprintf(TEXT("size of unsigned long : %d\n"), sizeof(unsigned long));
	_tprintf(TEXT("Looks like everything went ok :) "));
	
	_getch();

	

	UnmapViewOfFile(pBuf);

	CloseHandle(hMapFile);

	return 0;
}


