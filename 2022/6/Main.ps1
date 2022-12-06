[Cmdletbinding()]
Param([string]$InputFile)
$data = Get-Content $InputFile

$START_OF_PACK = 4
$START_OF_MSG = 14

function IsStartMarker([string]$value, [int]$Starter) {
    if (($value.ToCharArray() | Select-Object -Unique).Count -eq $Starter) {
        return $true
    }
    return $false
}

function GetFirstMarker([string]$line, $Starter) {
    $marker = $Starter
    for ($i = 0; ($i + $Starter) -le $line.Length; $i++) {
        $ss = $line.Substring($i, $Starter)
        if ($(IsStartMarker $ss $Starter)) { return $marker }
        $marker++
    }
}

foreach ($line in $data) {
    if ($line) {
        Write-Host $line
        $pack = GetFirstMarker $line $START_OF_PACK
        Write-Host "FIRST PACK MARKER : $pack"
        $msg = GetFirstMarker $line $START_OF_MSG
        Write-Host "FIRST MESSAGE MARKER : $msg"
        Write-Host
    }
}

