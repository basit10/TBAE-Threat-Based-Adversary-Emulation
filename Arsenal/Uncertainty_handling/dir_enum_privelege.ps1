# Paths that we've already excluded via AppLocker.
$exclusions = @()

# Paths to process.
$paths = @(
  "C:\Windows"
)

# Setup log.
$log = "$PSScriptRoot\UserWritableLocations.log"

$FSR = [System.Security.AccessControl.FileSystemRights]

# Unfortunately the FileSystemRights enum doesn't contain all the values from the Win32 API. Urgh.
$GenericRights = @{
  GENERIC_READ    = [int]0x80000000;
  GENERIC_WRITE   = [int]0x40000000;
  GENERIC_EXECUTE = [int]0x20000000;
  GENERIC_ALL     = [int]0x10000000;
  FILTER_GENERIC  = [int]0x0FFFFFFF;
}

# ... so we need to map them ourselves.
$MappedGenericRights = @{
  FILE_GENERIC_READ    = $FSR::ReadAttributes -bor $FSR::ReadData -bor $FSR::ReadExtendedAttributes -bor $FSR::ReadPermissions -bor $FSR::Synchronize
  FILE_GENERIC_WRITE   = $FSR::AppendData -bor $FSR::WriteAttributes -bor $FSR::WriteData -bor $FSR::WriteExtendedAttributes -bor $FSR::ReadPermissions -bor $FSR::Synchronize
  FILE_GENERIC_EXECUTE = $FSR::ExecuteFile -bor $FSR::ReadPermissions -bor $FSR::ReadAttributes -bor $FSR::Synchronize
  FILE_GENERIC_ALL     = $FSR::FullControl
}

Function Map-GenericRightsToFileSystemRights([System.Security.AccessControl.FileSystemRights]$Rights) {  
  $MappedRights = New-Object -TypeName $FSR

  if ($Rights -band $GenericRights.GENERIC_EXECUTE) {
    $MappedRights = $MappedRights -bor $MappedGenericRights.FILE_GENERIC_EXECUTE
  }

  if ($Rights -band $GenericRights.GENERIC_READ) {
   $MappedRights = $MappedRights -bor $MappedGenericRights.FILE_GENERIC_READ
  }

  if ($Rights -band $GenericRights.GENERIC_WRITE) {
    $MappedRights = $MappedRights -bor $MappedGenericRights.FILE_GENERIC_WRITE
  }

  if ($Rights -band $GenericRights.GENERIC_ALL) {
    $MappedRights = $MappedRights -bor $MappedGenericRights.FILE_GENERIC_ALL
  }

  return (($Rights -band $GenericRights.FILTER_GENERIC) -bor $MappedRights) -as $FSR
}

# These are the rights from the FileSystemRights enum we care about.
$WriteRights = @('WriteData', 'CreateFiles', 'CreateDirectories', 'WriteExtendedAttributes', 'WriteAttributes', 'Write', 'Modify', 'FullControl')

# Helper function to match against a list of patterns.
function notlike($string, $patterns) {  
  foreach ($pattern in $patterns) { if ($string -like $pattern) { return $false } }
  return $true
}

# The hard work...
function scan($path, $log) {  
  $cache = @()
  gci $path -recurse -exclude $exclusions -force -ea silentlycontinue |
  ? {($_.psiscontainer) -and (notlike $_.fullname $exclusions)} | %{
    trap { continue }
    $directory = $_.fullname
    (get-acl $directory -ea silentlycontinue).access |
    ? {$_.isinherited -eq $false} |
    ? {$_.identityreference -match ".*USERS|EVERYONE"} | %{
      (map-genericrightstofilesystemrights $_.filesystemrights).tostring().split(",") | %{
        if ($writerights -contains $_.trim()) {
          if ($cache -notcontains $directory) { $cache += $directory }
        }
      }
    }
  }
  return $cache
}

# Start scanning.
$paths | %{ scan $_ $log } | out-file $lo