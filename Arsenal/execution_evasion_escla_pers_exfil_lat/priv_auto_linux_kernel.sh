#/bin/bash

usage(){
	echo "[*] Usage: $0 VERSION_OF_KERNEL";
    echo "[*] Example: root~> $0 2.6";
	exit 1;
}

download(){

	base="/usr/share/exploitdb/platforms"
	echo "[*] The base directory is $base"

	[ -d "linux_$version" ] || mkdir linux_$version # make directory if not exist

	for file in $file_list; do
        echo "[*] Copying $base$file to $PWD/linux_$version/$file"
		cp $base$file linux_$version/ 
		file_extension=$(echo $file | cut -d '.' -f 2) # extract the file extension
		case $file_extension in
			"c" ) c_file_count=$((c_file_count+1));;
			"rb" ) rb_file_count=$((rb_file_count+1));;
			"txt" ) txt_file_count=$((txt_file_count+1));;
			"py" ) py_file_count=$((py_file_count+1));;
			"pl" ) pl_file_count=$((pl_file_count+1));;
		esac
	done
}

compile(){
	for file in $file_list; do
		file_extension=$(echo $file | cut -d '.' -f 2) # extract the file extension
		file_name=$(echo $file | cut -d '/' -f 4) #extrac the file name
		if [ "$file_extension" == "c" ]; then
			gcc linux_$version/$file_name -o linux_$version/"$file_name.exe" 2>/dev/null
		fi
	done
}

version=$1
file_list=$(searchsploit $version linux| grep local | grep -i privilege | cut -d '|' -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

py_file_count=0
txt_file_count=0
rb_file_count=0
c_file_count=0
pl_file_count=0

main(){
	echo -e "[*] Possible Exploit\n"
    searchsploit $version linux | grep local | grep -i privilege
    if [ -z $file_list ]; then
        echo "No possible exploit. Please use another version."
        exit 1
    fi

	echo "[*] Do you wish to download all the exploit script to current directory and compile if possible?"
	select yn in "Yes" "No"; do
		case $yn in
			Yes ) download;break;;
			No ) exit 1;;
		esac
	done
	echo "[*] Do you wish to compile all the exploit script written in C?"
	select yn in "Yes" "No"; do
		case $yn in
			Yes ) compile;break;;
			No ) break;;
		esac
	done
	exe_file_count=$(ls linux_$version | grep .exe -c)

	echo "[*] Do you want to make a tar ball of the linux_$version? (For convinient file transfer)"
	select yn in "Yes" "No"; do
		case $yn in
			Yes ) tar -cf linux_$version.tar linux_$version;break;;
			No ) break;;
		esac
	done

	echo "[*] Auto Privilege Exploit Summary"
	echo "C file in $PWD/linux_$version has $c_file_count files"
	echo "Python file in $PWD/linux_$version has $py_file_count files"
	echo "Perl file in $PWD/linux_$version has $pl_file_count files"
	echo "Ruby file in $PWD/linux_$version has $rb_file_count files"
	echo "TXT file in $PWD/linux_$version has $txt_file_count files"
    echo ""
	echo "[*] Successfully Compiled $exe_file_count executable located in linux_$version"
	
}


if [ $# -ne 1 ]; then
	usage
fi
main