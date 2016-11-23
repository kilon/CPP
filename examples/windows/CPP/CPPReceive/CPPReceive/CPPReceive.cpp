// CPPReceive.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"



#include <windows.h>
#include <stdio.h>
#include <conio.h>
#include <tchar.h>
#include <iostream>
#pragma comment(lib, "user32.lib")

#define BUF_SIZE 1000
TCHAR szName[] = TEXT("MyFileMappingObject");

int _tmain()
{
	HANDLE hMapFile;
	LPCTSTR pBuf;

	hMapFile = OpenFileMapping(
		FILE_MAP_ALL_ACCESS,   // read/write access
		FALSE,                 // do not inherit the name
		LPCWSTR("MyFileMappingObject"));               // name of mapping object

	if (hMapFile == NULL)
	{
		_tprintf(TEXT("Could not open file mapping object (%d).\n"),
			GetLastError());
		_getch();
		return 1;
	}

	std::cout << "hMapFile value : " << hMapFile << "\n";
	pBuf = (LPTSTR)MapViewOfFile(hMapFile, // handle to map object
		FILE_MAP_ALL_ACCESS,  // read/write permission
		0,
		0,
		BUF_SIZE);

	if (pBuf == NULL)
	{
		_tprintf(TEXT("Could not map view of file (%d).\n"),
			GetLastError());

		CloseHandle(hMapFile);
		_getch();
		return 1;
	}

	MessageBox(NULL, pBuf, TEXT("Process2"), MB_OK);

	_getch();

	UnmapViewOfFile(pBuf);

	CloseHandle(hMapFile);

	return 0;
}

