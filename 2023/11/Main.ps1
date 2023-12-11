[Cmdletbinding()]
Param([string]$InputFile)

function ProcessData ($data) {
    $matrix = @()
    foreach ($line in $data) { $matrix += , ($line.ToCharArray()) }

    $galaxyCoords = @()
    for ($x = 0; $x -lt $matrix.Count; $x++) {
        for ($y = 0; $y -lt $matrix[$x].Count; $y++) {
            if ($matrix[$x][$y] -eq '#') { $galaxyCoords += "$x,$y" }
        }
    }

    $script:emptyRows = 0..($matrix.Count - 1) | Where-Object { '#' -notin $matrix[$_] }
    $script:emptyCols = 0..($matrix[0].Count - 1) | Where-Object { $col = $_; -not ($matrix | ForEach-Object { $_[$col] } | Where-Object { $_ -eq '#' }) }

    $c1 = 0
    $c2 = 0
    for ($i = 0; $i -lt $galaxyCoords.Count; $i++) {
        for ($j = $i + 1; $j -lt $galaxyCoords.Count; $j++) {
            $c1 += GetCustomManhattanDistance $galaxyCoords[$i] $galaxyCoords[$j]
            $c2 += GetCustomManhattanDistance $galaxyCoords[$i] $galaxyCoords[$j] (1e6 - 1)
        }
    }

    return @{ c1 = $c1; c2 = $c2 }
}

function GetCustomManhattanDistance($a, $b, $expansion = 1) {
    $a = [int[]]$a.Split(",")
    $b = [int[]]$b.Split(",")
    $a1 = (@($a[0], $b[0]) | Measure-Object -Minimum).Minimum
    $b1 = (@($a[0], $b[0]) | Measure-Object -Maximum).Maximum
    $a2 = (@($a[1], $b[1]) | Measure-Object -Minimum).Minimum
    $b2 = (@($a[1], $b[1]) | Measure-Object -Maximum).Maximum

    $result = 0
    for ($i = $a1; $i -lt $b1; $i++) {
        $result += 1
        if ($i -in @($emptyRows)) { $result += $expansion } # space expansion
    }
    for ($j = $a2; $j -lt $b2; $j++) {
        $result += 1
        if ($j -in @($emptyCols)) { $result += $expansion } # space expansion
    }
    return $result
}


function Main {
    $data = $(Get-Content $InputFile)

    $result = ProcessData $data

    Write-Host "Challenge One: $($result.c1)"
    Write-Host "Challenge Two: $($result.c2)"
}

Main
