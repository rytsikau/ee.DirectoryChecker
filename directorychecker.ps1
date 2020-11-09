'-------------------------------------------------------------------------------------------------'
' ee.DirectoryChecker (2020-11-07)                                                                '
' Outputs information about each file/folder in the specified directory to a CSV file             '
' (format: "attributes","creation time","last write time","last access time","size","fullname")   '
'-------------------------------------------------------------------------------------------------'

Set-ExecutionPolicy Unrestricted -Scope CurrentUser
$erroractionpreference = "SilentlyContinue"
Remove-Variable *
$erroractionpreference = "Continue"

$dtStartTime = Get-Date
$dirInput = $args[0]

if (![System.IO.Path]::IsPathRooted($dirInput))
{
    Write-Host "Error! Specify the absolute path to the input directory"
    Exit
}
else
{
    $dirInput = $dirInput.Trim("\")
}

$dirInputFlat =
    $dirInput.Split([System.IO.Path]::GetInvalidFileNameChars()) -Join("_") -Replace " ","_"
$dirCsv = (Get-Item $psscriptroot -ErrorAction SilentlyContinue).FullName + "\results"
$csvFileName = "$($dtStartTime.ToString('yyyyMMdd_HHmmss'))_$dirInputFlat.csv"

Write-Host "Get info about files and folders located at: $dirInput\"
Write-Host "CSV file name: $csvFileName"
Write-Host "Processing..."

if (Test-Path $dirInput)
{
    $list = Get-ChildItem $dirInput -Force -Recurse -ErrorAction SilentlyContinue `
        | Select Mode, CreationTime, LastWriteTime, LastAccessTime, Length, FullName
}
else
{
    Write-Host "Error! Input directory not found"
    Exit
}

try
{
    New-Item $dirCsv -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
    $list | Export-Csv "$dirCsv\$csvFileName" -Encoding UTF8 -NoTypeInformation
}
catch
{
    Write-Host "Error! Unable to write output CSV file"
    Exit
}

$tsElapsed = ($(Get-Date) - $dtStartTime).TotalSeconds
$nItems = (Get-Content "$dirCsv\$csvFileName").Length - 1
Write-Host "Ready! Processed in $tsElapsed seconds, found $nItems files and folders"
'-------------------------------------------------------------------------------------------------'
