[Cmdletbinding()]
Param([string]$InputFile)

function ProcessData ($data) {
    $matrix = @()
    foreach ($line in $data) { $matrix += , ($line.ToCharArray()) }

    $map = @{}
    $start = $null
    for ($x = 0; $x -lt $matrix.Count; $x++) {
        for ($y = 0; $y -lt $matrix[$x].Count; $y++) {
            $nextDir = GetNextDirections $matrix $x $y
            if ($nextDir) { $map.Add("$x,$y", $nextDir) }
            if ($matrix[$x][$y] -eq "S") { $start = "$x,$y" }
        }
    }

    $current = $start
    $path = @($start)

    # Challenge 1
    while ($current -ne $start -or $path.Count -eq 1) {
        foreach ($dir in $map[$current]) {
            if ($path[$path.Count - 2] -ne $dir -and $map.ContainsKey($dir) -and @($map[$dir]) -contains $current) {
                $path += $dir
                $current = $dir
                break
            }
        }
    }

    # Challenge 2 : Ray casting algorithm (https://rosettacode.org/wiki/Ray-casting_algorithm)
    $matrix[$start.Split(",")[0]][$start.Split(",")[1]] = "|"
    $c2 = 0
    for ($x = 0; $x -lt $matrix.Count; $x++) {
        for ($y = 0; $y -lt $matrix[$x].Count; $y++) {
            if ("$x,$y" -notin @($path)) {
                $edgeCrossingCount = CountEdgeCrossing $matrix[$x] $path $x $y
                if ($edgeCrossingCount % 2 -eq 1) {
                    $c2 += 1
                }
            }
        }
    }

    return @{ c1 = $(($path.Count - 1) / 2); c2 = $c2 }
}

# If odd, element is inside the polygon
# If even, element is outside the polygon
function CountEdgeCrossing($line, $path, $x, $y) {
    $count = 0
    foreach ($k in 0..($y - 1)) {
        if ("$x,$k" -notin $path) { continue }
        $count += $line[$k] -in @( "J", "L", "|" )
    }
    return $count
}

function GetNextDirections($matrix, $x, $y) {
    switch ($matrix[$x][$y]) {
        "-" { return @("$x,$($y-1)", "$x,$($y+1)") }
        "|" { return @("$($x-1),$y", "$($x+1),$y") }
        "L" { return @("$x,$($y+1)", "$($x-1),$y") }
        "J" { return @("$x,$($y-1)", "$($x-1),$y") }
        "7" { return @("$x,$($y-1)", "$($x+1),$y") }
        "F" { return @("$x,$($y+1)", "$($x+1),$y") }
        "S" { return @("$($x-1),$y", "$($x+1),$y", "$x,$($y-1)", "$x,$($y+1)") }
        default { return $null }
    }
}

function Main {
    $data = $(Get-Content $InputFile)

    $result = ProcessData $data

    Write-Host "Challenge One: $($result.c1)"
    Write-Host "Challenge Two: $($result.c2)"
}

Main
