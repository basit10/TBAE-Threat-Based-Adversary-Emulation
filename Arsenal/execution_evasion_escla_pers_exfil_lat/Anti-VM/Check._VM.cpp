#include "Check_VM.h"
#include "windows.h"
#include "Hardware_Check.h"
#include "Activty_Check.h"
#include <iostream>

void Check_VM()
{
	Hardware_Check();
	Mouse_Movement();

}
