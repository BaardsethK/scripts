$user = [System.Environment]::UserName
$folders_created = 0
$files_moved = 0

$folderpath = Read-Host -Prompt "Enter folder path (standard is C:\users\$user\downloads\)"
if ([string]::IsNullOrEmpty($folderpath))
{
    $folderpath = "C:\users\$user\downloads\"
}
if ( -Not (Test-Path $folderpath))
{
    Write-Host "Path not found. Exiting..."
    Exit
}
Write-host 'Selected folder is ' $folderpath
$file_extensions = Get-ChildItem -path $folderpath -File | Select-Object -ExpandProperty Extension -Unique

Write-Host "Creating folders..."
foreach($extension in $file_extensions)
{
    $full_path = join-path -path $folderpath -ChildPath $extension
    if ( -Not (Test-Path $full_path) -And $extension.Length -gt 0)
    {
        New-Item -ItemType Directory -path $full_path
        $folders_created++
    }
    $moved_files = Move-Item -Path "$folderpath*?$extension" -Destination $full_path -PassThru
    $files_moved += $moved_files.Length
}

Write-Host "Created $folders_created folders. Moved $files_moved files into folders."
