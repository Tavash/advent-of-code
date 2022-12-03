[Cmdletbinding()]
Param([string]$InputFile)
$data = Get-Content $InputFile

$count = 1
$GROUP_COUNT = 3

$tmpList = [System.Collections.ArrayList]::new()
$newList = @{}

foreach ($line in $data) {
    if ($line) {
        $tmpList.Add($line) | Out-Null
        if (($count % $GROUP_COUNT) -eq 0) {
            $newList.Add($count, $tmpList)
            $tmpList = [System.Collections.ArrayList]::new()
        }
        $count++
    }
}

function findBadge([string[]]$groups) {
    $countChar = ($groups[0] | Measure-Object -Character).Characters

    for ($j = 0; $j -lt $countChar; $j++) {
        $charTmp = $groups[0].Substring($j, 1)
        if ([regex]::match($groups[1], $charTmp).Success -and [regex]::match($groups[2], $charTmp).Success) {
            return $charTmp
        }
    }
}

$total = 0
foreach ($h in $newList.GetEnumerator() ) {
    $val = findBadge $h.Value
    if ($val -cmatch "^[a-z]*$") {
        $total += ([int]([char]$val) - 96)
    }
    else {
        $total += ([int]([char]$val) - 38)
    }
}

Write-Output "TOTAL : $total"
