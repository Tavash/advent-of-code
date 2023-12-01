[Cmdletbinding()]
Param([string]$InputFile)
$data = Get-Content $InputFile

$heightmap = [System.Collections.Generic.List[System.Collections.Generic.List[string]]]::new()

# Build matrix
foreach ($line in $data) {
    if ($line) {
        $heightmap.Add($($line.ToCharArray()))
    }
}

# S : start
# E : end

function FindEnd() {
    for ($i = 0; $i -lt ($heightmap.Count - 1); $i++) {
        for ($j = 0; $j -lt ($heightmap[$i].Count - 1); $j++) {
            if ($heightmap[$i][$j] -eq "E") {
                return @{ i = $i; j = $j }
            }
        }
    }
}

# $start = $heightmap[0][0]
# $endCoords = FindEnd

function GetAllowedMoves($i, $j) {
    $current = $heightmap[$i][$j]
    if ($current -eq "S") { $current = "a" }
    elseif ($current -eq "E") { $current = "z" }
    $currentValue = [int]([char]"$current")
    # Write-Host "CURRENT LETTER : $current"

    $moves = @{ U = $false; L = $false; D = $false; R = $false }

    # UP
    if (($i - 1) -gt 0) {
        $upValue = [int]([char]"$($heightmap[$i - 1][$j])")
        $moves.U = ($upValue -eq $currentValue -or $upValue -eq ($currentValue + 1))
    }
    # LEFT
    if (($j - 1) -gt 0) {
        $leftValue = [int]([char]"$($heightmap[$i][$j -1])")
        $moves.L = ($leftValue -eq $currentValue -or $leftValue -eq ($currentValue + 1))
    }
    # DOWN
    if (($i + 1) -lt $heightmap.Count) {
        $downValue = [int]([char]"$($heightmap[$i + 1][$j])")
        $moves.D = ($downValue -eq $currentValue -or $downValue -eq ($currentValue + 1))
    }
    # RIGHT
    if (($j + 1) -lt $heightmap[$i].Count) {
        $rightValue = [int]([char]"$($heightmap[$i][$j + 1])")
        $moves.R = ($rightValue -eq $currentValue -or $rightValue -eq ($currentValue + 1))
    }
    return $moves
}

$result = [System.Collections.Generic.Dictionary[string, int]]::new()

for ($i = 0; $i -lt $heightmap.Count; $i++) {
    for ($j = 0; $j -lt $heightmap[$i].Count; $j++) {
        $current += $heightmap[$i][$j]
        # if ($i -gt 0 -and $i -lt ($table.Count - 1) -and $j -gt 0 -and $j -lt ($table[$i].Count - 1)) {
        # }
        
    }
}
