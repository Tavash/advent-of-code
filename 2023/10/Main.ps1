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

    return @{ c1 = $(($path.Count - 1) / 2) }
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
    # Write-Host "Challenge Two: $($result.c2)"
}

Main
