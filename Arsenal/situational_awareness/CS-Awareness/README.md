## Available commands
|command|Usage|notes|
|-------|-----|-----|
|arp|arp| Lists ARP table|
| adv_audit_policies | adv_audit_policies | Retrieves advanced security audit policies |
|cacls|cacls [filepath]|lists user permissions for the specified file, wildcards supported|
|dir|dir [directory] [/s]|List files in a directory. Supports wildcards (e.g. "C:\Windows\S*") the CobaltStrike `ls` command|
|driversigs|driversigs| enumerate installed services Imagepaths to check the signing cert against known edr/av vendors|
|enum_filter_driver|enum_filter_driver [opt:computer] | Enumerates all the filter drivers|
|enumLocalSessions|enumLocalSessions| Enumerate the currently attached user sessions both local and over rdp|
|env|env| Prints process environment variables|
|ipconfig|ipconfig| Simply gets ipv4 addresses, hostname and dns server|
|ldapsearch|ldapsearch [query] [opt: attribute] [opt: results_limit] | Executes LDAP searches |
|listdns|listdns| Pulls dns cache entries, attempts to query and resolve each|
|listmods|listmods [opt: pid]| List a process modules (DLL). Target current process if pid is empty. Complement to driversigs to determine if our process was injected by edr/av.|
|listpipes|listpipes| Lists named pipes|
|netstat|netstat| tcp / udp ipv4 netstat listing|
|netuser|netuser [username] [opt: domain]| Pulls info about specific user.  Pulls from domain if a domainname is specified|
|netview|netview| Gets a list of reachable servers in the current domain|
|netGroupList|netGroupList [opt: domain]|Lists Groups from the default (or specified) domain|
|netGroupListMembers|netGroupListMembers [groupname] [opt: domain]| Lists group members from the default (or specified) domain|
|netLocalGroupList|netLocalGroupList [opt: server]|List local groups from the local (or specified) computer|
|netLocalGroupListMembers|netLocalGroupListMembers [groupname] [opt: server]| Lists local groups from the local (or specified) computer|
|nslookup|nslookup [hostname] [opt:dns server] [opt: record type]| Makes a dns query.<br/>  dns server is the server you want to query (do not specify or 0 for default) <br/>record type is something like A, AAAA, or ANY.  Some situations are limited due to observed crashes.|
|reg_query|[opt:hostname] [hive] [path] [opt: value to query]|queries a registry value or enumerates a single key|
|reg_query_recursive|[opt:hostname] [hive] [path]| recursively enumerates a key starting at path|
|routeprint|routeprint| prints ipv4 configured routes|
|schtasksenum|schtasksenum [opt: server]| Enumerates all scheduled tasks on the local or if provided remote machine|
|schtasksquery|schtasksquery [opt: server] [taskpath]| Queries the given task from the local or if provided remote machine|
|sc_enum| sc_enum [opt:server] | Enumerates all services for qc, query, qfailure, and qtriggers info |
|sc_qc|sc_qc [service name] [opt:server]| sc qc impelmentation in bof|
|sc_qfailure|sc_qfailure [service name] [opt:server] | Queries a service for failure conditions |
|sc_qtriggerinfo|sc_qtriggerinfo [service name] [opt:server] | Queries a service for trigger conditions |
|sc_query|sc_query [opt: service name] [opt: server]| sc query implementation in bof|
|sc_qdescription|sc_qdescription [service name] [opt: server] | sc qdescription implementation in bof|
|tasklist|tasklist [opt: server]| Get a list of running processes including PID, PPID and ComandLine (uses wmi)|
|whoami|whoami| simulates whoami /all|
|windowlist|windowlist [opt:all]| lists visible windows in the current users session|
|wmi_query|wmi_query query [opt: server] [opt: namespace]| Run a wmi query and display results in CSV format|
|netsession|netsession [opt:computer] | Enumerates all sessions on the specified computer or the local one|
|resources|resources| Prints memory usage and available disk space on the primary hard drive|
|uptime|uptime| Prints system boot time and how long it's been since then|

Note the reason for including reg_query when CS has a built in reg query(v) command is because this one can target remote systems and has the ability to recursively enumerate a whole key.


#### credits
The functional code for most of these commands was taken from the reactos project or code examples hosted on MSDN.  
The driversigs codebase comes from https://gist.github.com/jthuraisamy/4c4c751df09f83d3620013f5d370d3b9 & Trustedsec orignal repo

Thank you to all of the contributors listed under contributors.  Each have contributed something meaningful to this repository and dealt with me and my review processes.  I appreciate each and every one of them for teaching me and helping to make this BOF repository the best it can be!

##### compiler used
Precompiled BOF's are provided in this project and are compiled using a recent version of Mingw-w64 typcially installed from brew.


