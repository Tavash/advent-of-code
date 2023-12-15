[Cmdletbinding()]
Param([string]$InputFile)
$data = Get-Content $InputFile

$table = [System.Collections.Generic.List[System.Collections.Generic.List[Int]]]::new()

foreach ($line in $data) {
    if ($line) {
        $table.Add($($line.ToCharArray() | ForEach-Object { return [int]::Parse($_) }))
    }
}

function IsNotVisible($i, $j) {
    $result = @{ up = $false; left = $false; down = $false; right = $false }
    $cur = $table[$i][$j]
    for ($x = ($i - 1); $x -ge 0; $x--) {
        if ($table[$x][$j] -ge $cur) { $result.up = $true; break; }
    }
    for ($x = ($j - 1); $x -ge 0; $x--) {
        if ($table[$i][$x] -ge $cur) { $result.left = $true; break; }
    }
    for ($x = ($i + 1); $x -lt $table.Count; $x++) {
        if ($table[$x][$j] -ge $cur) { $result.down = $true; break; }
    }
    for ($x = ($j + 1); $x -lt $table[$i].Count; $x++) {
        if ($table[$i][$x] -ge $cur) { $result.right = $true; break; }
    }
    # Write-Host "($i,$j) => $cur (UP: $up, LEFT: $result.left, DOWN: $result.down, RIGHT: $result.right)"
    return $result.up -and $result.left -and $result.down -and $result.right
}

function GetScenicScore($i, $j) {
    $result = @{ up = 0; left = 0; down = 0; right = 0 }
    $cur = $table[$i][$j]
    for ($x = ($i - 1); $x -ge 0; $x--) {
        if ($cur -gt $table[$x][$j]) { $result.up++; } elseif ($cur -le $table[$x][$j]) { $result.up++; break; } else { $result.up++; break; }
    }
    for ($x = ($j - 1); $x -ge 0; $x--) {
        if ($cur -gt $table[$i][$x]) { $result.left++; } elseif ($cur -le $table[$i][$x]) { $result.left++; break; } else { $result.left++; break; }
    }
    for ($x = ($i + 1); $x -lt $table.Count; $x++) {
        if ($cur -gt $table[$x][$j]) { $result.down++; } elseif ($cur -le $table[$x][$j]) { $result.down++; break; } else { $result.down++; break; }
    }
    for ($x = ($j + 1); $x -lt $table[$i].Count; $x++) {
        if ($cur -gt $table[$i][$x]) { $result.right++; } elseif ($cur -le $table[$i][$x]) { $result.right++; break; } else { $result.right++; break; }
    }
    # Write-Host "($i,$j) => $cur (UP: $result.up, LEFT: $result.left, DOWN: $result.down, RIGHT: $result.right)"
    return $result.up * $result.left * $result.down * $result.right
}

$totalVisibleCount = 0
$maxScenicScore = 0
for ($i = 0; $i -lt ($table.Count - 1); $i++) {
    for ($j = 0; $j -lt ($table[$i].Count - 1); $j++) {
        if ($i -gt 0 -and $i -lt ($table.Count - 1) -and $j -gt 0 -and $j -lt ($table[$i].Count - 1)) {
            if (!$(IsNotVisible $i $j)) {
                $totalVisibleCount++
            }
            $tmpMaxScenicScore = GetScenicScore $i $j
            if ($tmpMaxScenicScore -gt $maxScenicScore) {
                $maxScenicScore = $tmpMaxScenicScore
            }
        }
    }
}

$totalVisibleCount += ($table.Count * $table[0].Count - ($table.Count - 2) * ($table[0].Count - 2))

Write-Host "1) TOTAL VISIBLE : $totalVisibleCount"

Write-Host "2) MAX SCENIC SCORE : $maxScenicScore"