// CopyToClipboard.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#using <System.dll>
#using <System.Drawing.dll>
#using <System.Windows.Forms.dll>

using namespace System;
using namespace System::Windows::Forms;

/**
* Console program copies given string to clipboard. Code snippet taken from
* https://msdn.microsoft.com/de-de/library/93ks5wxz.aspx
*
* Visual Studio C++ Options:
* - Common Language RunTime Support /clr
* - Debug Information Format None
* - Enable C++ Exceptions No
* - Enable Function-Level Linking No
* - Enable Intrinsic Functions No
* - Whole Program Optimization No
**/
[STAThread] int main(int argc, char* argv[])
{
	if (argc == 2 && argv[1]) {
		String^ str = gcnew String(argv[1]);
		// Use 'true' as the second argument if
		// the data is to remain in the clipboard
		// after the program terminates.
		Clipboard::SetDataObject(str, true);
		Console::WriteLine("Text copied to the Clipboard.");
	}

    return 0;
}

