<#
Archivator - To archive your files quickly and easily. 

/*\ Description

.PARAMETER: FilesPath
The directory containing your files

.PARAMETER: FileExtension
The type of files to archive

.PARAMETER: DaysToKeep
Sets the days to ignore while archiving

.PARAMETER: ArchivePath
The directory where all compressed files will be moved to

/*\ Example

.\Archivator -FilesPath "D:\Extracts\" -FileExtension "*.txt" -DaysToKeep 3 -ArchivePath "D:\Extracts\Archive" 

This command will zip all txt files in D:\Extracts older than from J-3 and move them to D:\Extracts\Archive

/*\ Notes

.Github:

.Author: Bilel Msekni

This script is based on a script written by Paul Cunningham: http://exchangeserverpro.com/powershell-script-iis-logs-cleanup
#>

# -1- Parameters

[CmdletBinding()]
param (
[Parameter(Mandatory=$true)]
[string]$FilesPath,

[Parameter(Mandatory=$true)]
[string]$FileExtension,

[Parameter(Mandatory=$true)]
[int]$DaysToKeep,

[Parameter(Mandatory=$false)]
[string]$ArchivePath
)

# -2- Variables

$sleepinterval = 5
$now = Get-Date
$currentmonth = ($now).Month
$currentyear = ($now).Year
$currentday = ($now).Day
$firstdaytosave = ($now).AddDays(-$DaysToKeep)

$logSubFolderName = "$currentday-$currentmonth-$currentyear"
set-alias sevenzip "C:\Program Files\7-Zip\7z.exe"

# -3- Functions

# Check if Files Path exist
if ((Test-Path $FilesPath) -ne $true)
{
$msg = "Files path: $FilesPath not found"
Write-Warning $msg
EXIT
}

$filesToArchive = Get-ChildItem -Path "$($FilesPath)\*.*" -Include $FileExtension | Where {$_.CreationTime -lt $firstdaytosave -and $_.PSIsContainer -eq $false}

if ($($filesToArchive.Count) -eq $null)
{
	$msg = "No files were found inside $FilesPath !!"
	Write-Warning $msg
	EXIT
}
else
{
	$filesCount = $($filesToArchive.Count)
	$msg = "$filesCount files were found inside $FilesPath earlier than $firstdaytosave"
	Write-Host $msg
}

if ((Test-Path $FilesPath\$logSubFolderName) -ne $true)
{
$msg = "$logSubFolderName do not exist. Creating it ..."
Write-Warning $msg
New-Item -Path $FilesPath\$logSubFolderName -ItemType Directory
}

foreach($file in $filesToArchive)
{
	try
	{
		$fn = $file.BaseName
		$zipfilename = "$FilesPath\$logSubFolderName\$fn.7z"
		sevenzip a -tzip $zipfilename $file
		Remove-Item $file -ErrorAction STOP
		$zippedCount = $zippedCount + 1
		
		Start-sleep -s $sleepinterval
	}
	catch
	{
		$msg = "Unable to zip $file"
		Write-Host $msg
		Write-Warning $_.Exception.Message
	}
}

$msg_1  = "Files found : $filesCount"
$msg_2  = "Files zipped : $zippedCount"
Write-Host msg_1
Write-Host msg_2

if($zippedCount -eq $filesCount)
{
	$msg = "All files have been zipped. Safe to proceed"
	Write-Host $msg
	
	if ($ArchivePath)
	{
		if((Test-Path $ArchivePath) -ne $true)
		{
			$msg  = "Log path $ArchivePath not found or inaccessible"
			Write-Warning $msg
		}
		else
		{
			$ZippedFileFolder = "$FilesPath\$logSubFolderName"
			Move-Item $ZippedFileFolder -Destination $ArchivePath\ -ErrorAction STOP
			$msg = "$ZippedFileFolder was moved to $ArchivePath"
			Write-Host $msg
		}
	}
}
else
{
	$msg = "Some files were not zipped, not safe to delete"
	Write-Host $msg
}