[Cmdletbinding()]
Param([string]$InputFile)
$data = Get-Content $InputFile

$result = @{}
$count = 1


function BuildSection([string]$pair) {
    $splitted = $pair -split '-'
    $res = [System.Collections.Generic.List[int]]::new()
    for ($i = [int]$splitted[0]; $i -le [int]$splitted[1]; $i++) {
        $res.Add($i)
    }
    return $res
}

function IsOverlapping([int[]]$first, [int[]]$second) {
    foreach ($v in $first) {
        if ($second -contains $v) {
            return $true
        }
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