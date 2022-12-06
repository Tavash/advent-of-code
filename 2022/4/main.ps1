[Cmdletbinding()]
Param([string]$InputFile)
$data = Get-Content $InputFile

$count = 1

function BuildSection1([string]$pair) {
    $splitted = $pair -split '-'
    for ($i = [int]$splitted[0]; $i -le [int]$splitted[1]; $i++) {
        $section += "#$i#"
    }
    return [string]"$section"
}

function IsOverlapping1([string]$first, [string]$second) {
    if ($first -match $second -or $second -match $first) {
        return $true
    }
    return $false
}

function BuildSection2([string]$pair) {
    $splitted = $pair -split '-'
    $res = [System.Collections.Generic.List[int]]::new()
    for ($i = [int]$splitted[0]; $i -le [int]$splitted[1]; $i++) {
        $res.Add($i)
    }
    return $res
}

function IsOverlapping2([int[]]$first, [int[]]$second) {
    foreach ($v in $first) {
        if ($second -contains $v) {
            return $true
        }
    }
    return $false
}

$count1 = 0
$count2 = 0
foreach ($line in $data) {
    if ($line) {
        $elves = $line -split ","
        if ($(IsOverlapping1 (BuildSection1 $elves[0]) (BuildSection1 $elves[1]))) {
            $count1++
        }
        if ($(IsOverlapping2 (BuildSection2 $elves[0]) (BuildSection2 $elves[1]))) {
            $count2++
        }
    }
}

Write-Output "1) TOTAL OVERLAP: $count1"
Write-Output "2) TOTAL OVERLAP: $count2"
