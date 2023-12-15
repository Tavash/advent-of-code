[Cmdletbinding()]
Param([string]$InputFile)
$data = Get-Content $InputFile

$array = $data.ToCharArray()

$floor = 0
$i = 1
$firstBasement = 0
$array | ForEach-Object {
    if ($_ -eq "(") { $floor++ }
    else { $floor-- }
    if ($floor -eq -1 -and $firstBasement -eq 0) { $firstBasement = $i }
    $i++
}

Write-Host "FINAL FLOOR : $floor"
Write-Host "FIRST TIME HIT BASEMENT POSITION : $firstBasement"
