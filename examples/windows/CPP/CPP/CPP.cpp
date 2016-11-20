// CPP.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <windows.h>
#include <stdio.h>
#include <conio.h>
#include <tchar.h>

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
	_tprintf(TEXT("Looks like everything went ok :) "));
	
	_getch();

	

	UnmapViewOfFile(pBuf);

	CloseHandle(hMapFile);

	return 0;
}


