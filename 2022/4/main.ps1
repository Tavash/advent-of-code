[Cmdletbinding()]
Param([string]$InputFile)
$data = Get-Content $InputFile

$result = @{}
$count = 1


function BuildSection([string]$pair) {
    $splitted = $pair -split '-'
    for ($i = [int]$splitted[0]; $i -le [int]$splitted[1]; $i++) {
        $section += "#$i#"
    }
    return [string]"$section"
}

function IsOverlapping([string]$first, [string]$second) {
    if ($first -match $second -or $second -match $first) {
        return $true
    }
    return $false
}

$count = 0
foreach ($line in $data) {
    if ($line) {
        $elves = $line -split ","
        if ($(IsOverlapping (BuildSection $elves[0]) (BuildSection $elves[1]))) {
            $count++
        }
    }
}

Write-Output "TOTAL OVERLAP: $count"