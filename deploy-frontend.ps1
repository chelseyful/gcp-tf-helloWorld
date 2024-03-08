#!pwsh
#REQUIRES -Version 4.0
$rightHere = $MyInvocation.MyCommand | Split-Path -Parent
$path_file = "${rightHere}/var/bucket_url.txt"
$local_path = "${rightHere}/frontend/dist/browser"
$bucket_path = ""

Write-Host "Testing environment..."
if (Test-Path -PathType Container $local_path) {
    Write-Host "Frontend path OK!"
} else {
    Write-Error "Frontend not built! Aborting"
    exit
}
if (Test-Path -PathType Leaf $path_file) {
    Write-Host "Path file exists!"
    $bucket_path = Get-Content $path_file
} else {
    Write-Error "Could not find path file! Aborting"
    exit
}

if ([string]::IsNullOrEmpty($bucket_path)) {
    Write-Error "bucket path is not valid!"
    exit
}

&"gsutil" "cp" "-ceJr" "${local_path}/*" "${bucket_path}"
