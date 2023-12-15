[Cmdletbinding()]
Param([string]$InputFile)
$data = Get-Content $InputFile

class Point {
    [int]$X
    [int]$Y
    [string]$Pos
    Point([int]$x, [int]$y) {
        $this.X = $x
        $this.Y = $y
        $this.Pos = "($($this.X),$($this.Y))"
    }
    Move([Point]$point) {
        $this.X += $point.X
        $this.Y += $point.Y
    }
    [string]GetPos() {
        return "($($this.X),$($this.Y))"
    }
    [int]ManhattanDistance([Point]$point) {
        return [Math]::Abs($this.X - $point.X) + [Math]::Abs($this.Y - $point.Y)
    }
    [bool]IsSameXY([Point]$point) {
        return ($this.X -eq $point.X -or $this.Y -eq $point.Y)
    }
    [bool]IsSameX([Point]$point) {
        return ($this.X -eq $point.X)
    }
    [bool]IsSameY([Point]$point) {
        return ($this.Y -eq $point.Y)
    }
}

[int]$knotCount = 10
$snake = [System.Collections.Generic.List[Point]]::new()

for ($i = 0; $i -lt $knotCount; $i++) {
    $snake.Add([Point]::new(0, 0))
}

$directionMoves = @{
    U = [Point]::new(0, 1)
    L = [Point]::new(-1, 0)
    D = [Point]::new(0, -1)
    R = [Point]::new(1, 0)
}

function GetOppositeDir($direction) {
    if ($direction -eq "U") {
        return "D"
    }
    elseif ($direction -eq "D") {
        return "U"
    }
    elseif ($direction -eq "L") {
        return "R"
    }
    elseif ($direction -eq "R") {
        return "L"
    }
}

$tailVisitedCoords = [System.Collections.Generic.List[string]]::new()

foreach ($line in $data) {
    if ($line) {
        $splitted = $line -split " "

        for ($i = 0; $i -lt [int]$splitted[1]; $i++) {

            $snake[0].Move($directionMoves[$splitted[0]])

            for ($j = 1; $j -lt $knotCount; $j++) {
                # if ($snake[$j - 1].IsSameXY($snake[$j]) -and $snake[$j - 1].ManhattanDistance($snake[$j]) -eq 2) {
                #     $snake[$j].Move($directionMoves[$splitted[0]])
                # }
                # elseif (!$snake[$j - 1].IsSameXY($snake[$j]) -and $snake[$j - 1].ManhattanDistance($snake[$j]) -ge 3) {
                #     $copy = [Point]::new($snake[$j - 1].X, $snake[$j - 1].Y)
                #     $copy.Move($directionMoves[$(GetOppositeDir $splitted[0])])
                #     $snake[$j].X = $copy.X # $snake[$j - 1].X
                #     $snake[$j].Y = $copy.Y # $snake[$j - 1].Y
                # }

                if (($snake[$j].ManhattanDistance($snake[$j - 1]) -ge 3 -and !$snake[$j - 1].IsSameXY($snake[$j])) -or ($snake[$j].ManhattanDistance($snake[$j - 1]) -eq 2 -and $snake[$j - 1].IsSameXY($snake[$j]))) {
                    if (!$snake[$j - 1].IsSameX($snake[$j])) {
                        $snake[$j].X += ($snake[$j - 1].X - $snake[$j].X) / [Math]::Abs($snake[$j - 1].X - $snake[$j].X)
                    }
                    if (!$snake[$j - 1].IsSameY($snake[$j])) {
                        $snake[$j].Y += ($snake[$j - 1].Y - $snake[$j].Y) / [Math]::Abs($snake[$j - 1].Y - $snake[$j].Y)
                    }
                }
            }
            # Write-Host "T($($snake[1].X), $($snake[1].Y)), H($($snake[0].X), $($snake[0].Y))"
            $tailVisitedCoords.Add($snake[$knotCount - 1].GetPos())
        }
    }
}

Write-Host "THERE ARE $(($tailVisitedCoords | Select-Object -Unique).Count) POSITIONS THE TAIL VISITED AT LEAST ONCE"
