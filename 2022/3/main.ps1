[Cmdletbinding()]
Param([string]$InputFile)
$data = Get-Content $InputFile

$result = [System.Collections.Generic.List[System.Collections.Generic.List[string]]]::new()

foreach ($line in $data) {
    if ($line) {
        $countChar = ($line | Measure-Object -Character).Characters
        $countHalf = [int]($countChar / 2)
        $firstHalf = $line.Substring(0, $countHalf)
        $secondHalf = $line.Substring($countHalf, $countHalf)

        $tmpList = [System.Collections.Generic.List[string]]::new()
        for ($i = 0; $i -lt $countHalf; $i++) {
            $charTmp = $firstHalf.Substring($i, 1)

            if ([regex]::match($secondHalf, $charTmp).Success) {
                $tmpList.Add($charTmp) | Out-Null
            }
        }
        $result.Add(@($tmpList | Select-Object -Unique))
    }
}

$total = 0
foreach ($h in $result) {
    foreach ($val in $h) {
        if ($val -cmatch "^[a-z]*$") {
            $total += ([int]([char]$val) - 96)
        }
        else {
            $total += ([int]([char]$val) - 38)
        }
    }
}

Write-Output "1) TOTAL : $total"

$count = 1
$GROUP_COUNT = 3

$result = [System.Collections.Generic.List[System.Collections.Generic.List[string]]]::new()
$tmpList = [System.Collections.Generic.List[string]]::new()

foreach ($line in $data) {
    if ($line) {
        $tmpList.Add($line) | Out-Null
        if (($count % $GROUP_COUNT) -eq 0) {
            $result.Add($tmpList)
            $tmpList = [System.Collections.Generic.List[string]]::new()
        }
        $count++
    }
}

function FindBadge([System.Collections.Generic.List[string]]$groups) {
    for ($j = 0; $j -lt $groups[0].Length; $j++) {
        $charTmp = $groups[0].Substring($j, 1)
        if ([regex]::match($groups[1], $charTmp).Success -and [regex]::match($groups[2], $charTmp).Success) {
            return $charTmp
        }
    }
}

$total = 0
foreach ($h in $result) {
    $val = FindBadge $h
    if ($val -cmatch "^[a-z]*$") {
        $total += ([int]([char]$val) - 96)
    }
    else {
        $total += ([int]([char]$val) - 38)
    }
}

Write-Output "2) TOTAL : $total"
