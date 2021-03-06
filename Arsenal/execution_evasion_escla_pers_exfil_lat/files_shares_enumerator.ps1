$start = "$(get-date) started"
write-host $start


$AD = [adsisearcher]"objectcategory=computer"
$Computers = $AD.FindAll()
$ComputerNames = $Computers.Properties.dnshostname
$FileShares = New-Object "System.Collections.Generic.List[string]" 




# *.bak -> Microsoft SQL backup files
# *password*.txt - text files with the name password
# *password*.xls - excel files with the name password
# web.config - web configuration file and may contains passwords
# app.config - application configuration file and may contains passwords
# *.ppk - Putty Private Key
# *.pk - OpenSSH Private Key


$SearchTerm = "*.BAK", "*password*.txt", "*password*.xls", "web.config", "app.config", "*.ppk", "*.pk"

foreach ($ComputerName in $ComputerNames) 
{ 
    try 
    {
        $connected = (Test-Connection -BufferSize 32 -Count 1 -ComputerName $ComputerName -Quiet -ErrorAction Ignore)
       
        if ($connected)
        {
            
            $Shares = net view \\$ComputerName /all 2>&1 | select-object -Skip 7 |  ?{$_ -match 'disk*'} | %{$_ -match '^(.+?)\s+Disk*'|out-null;$matches[1]} 

            foreach ($Share in $Shares)
            {                                          
                $line = "\\$ComputerName\$Share"
                $FileShares.Add($line)                                                           
            }    
        }
    }
    catch
    {
        Write-Host $_.Exception.Message
        Write-Host $_.Exception
      
    }
} 

$OpenShareList = @()
$MatchingFileList = @()

 ForEach ($FullSharePath in $FileShares)   
 {

    if (Test-Path $FullSharePath -ErrorAction SilentlyContinue )
    {
        Write-Host "Searching $FullSharePath"

        $OpenShareList += $FullSharePath
    
        $RootFolders = New-Object "System.Collections.Generic.List[string]" 
        #check the root folder for the string
        $RootFilesFound = Get-ChildItem -Path $FullSharePath  -File -ErrorAction SilentlyContinue -WarningAction SilentlyContinue  -Include $SearchTerm       
        foreach ($file in $RootFilesFound)
        {
            Write-Host "Matching File --> $file"          
            $MatchingFileList += $file.FullName
        }        

        $FolderList = Get-ChildItem $FullSharePath -Directory -ErrorAction SilentlyContinue -WarningAction SilentlyContinue 

        foreach ($Folder in $FolderList) 
        {
            if ($Folder.FullName -notlike "*Windows*" -and $Folder.FullName -notlike "*Program Files*" -and $Folder.FullName -notlike "*Admin$*") 
            {
                $RootFolders.Add($Folder.FullName)
            }
        } 
        
        foreach ($Folder in $RootFolders)
        {
            $FilesFound = Get-ChildItem -Path $Folder -Recurse -File -ErrorAction SilentlyContinue -WarningAction SilentlyContinue  -Include $SearchTerm
                
            foreach ($file in $FilesFound)
            {
                Write-Host "Matching File --> $file" 
                $MatchingFileList += $file.FullName
            }                        
        }   
    }
} 

$end = "$(get-date) ended"

$MatchingFileList | out-file "C:\temp\MatchingFiles.txt"
$OpenShareList | Out-File "C:\temp\OpenFileShares.txt"

Write-Host $end

Write-Host "*********************************************************************"
Write-Host 'Output is in C:\temp\MatchingFiles.txt and C:\temp\OpenFileShares.txt'
Write-Host "*********************************************************************"
write-host "done"