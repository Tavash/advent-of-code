[Cmdletbinding()]
Param([string]$InputFile)
$data = Get-Content $InputFile

$power = @{
    ROCK     = @{ Name = "ROCK"; Score = 1 }
    PAPER    = @{ Name = "PAPER"; Score = 2 }
    SCISSORS = @{ Name = "SCISSORS"; Score = 3 }
}
$rules2 = @{
    A = $power.ROCK
    B = $power.PAPER
    C = $power.SCISSORS
    X = $power.ROCK
    Y = $power.PAPER
    Z = $power.SCISSORS
}

$scores = @{
    W = 6
    D = 3
    L = 0
}

function CalculatePoints1($op, $me) {
    if ($op -eq $me) {
        return $scores.D + $power[$me].Score
    }
    else {
        if ($op -eq $power.ROCK.Name) {
            if ($me -eq $power.PAPER.Name) { return $scores.W + $power.PAPER.Score }
            else { return $scores.L + $power.SCISSORS.Score }
        }
        elseif ($op -eq $power.PAPER.Name) {
            if ($me -eq $power.ROCK.Name) { return $scores.L + $power.ROCK.Score }
            else { return $scores.W + $power.SCISSORS.Score }
        }
        elseif ($op -eq $power.SCISSORS.Name) {
            if ($me -eq $power.ROCK.Name) { return $scores.W + $power.ROCK.Score }
            else { return $scores.L + $power.PAPER.Score }
        }
    }
}

function CalculatePoints2($op, $me) {
    if ($op -eq $power.ROCK.Name) {
        if ($me -eq $power.ROCK.Name) { return $scores.L + $power.SCISSORS.Score }
        elseif ($me -eq $power.PAPER.Name) { return $scores.D + $power.ROCK.Score }
        else { return $scores.W + $power.PAPER.Score }
    }
    elseif ($op -eq $power.PAPER.Name) {
        if ($me -eq $power.ROCK.Name) { return $scores.L + $power.ROCK.Score }
        elseif ($me -eq $power.PAPER.Name) { return $scores.D + $power.PAPER.Score }
        else { return $scores.W + $power.SCISSORS.Score }
    }
    elseif ($op -eq $power.SCISSORS.Name) {
        if ($me -eq $power.ROCK.Name) { return $scores.L + $power.PAPER.Score }
        elseif ($me -eq $power.PAPER.Name) { return $scores.D + $power.SCISSORS.Score }
        else { return $scores.W + $power.ROCK.Score }
    }
}

$totalPoints1 = 0
$totalPoints2 = 0

foreach ($line in $data) {
    if ($line) {
        $splitted = $line -split " "
        $totalPoints1 += CalculatePoints1 $rules2[$splitted[0]].Name $rules2[$splitted[1]].Name
        $totalPoints2 += CalculatePoints2 $rules2[$splitted[0]].Name $rules2[$splitted[1]].Name
    }
}

$totalPoints1
$totalPoints2
## TOP 1 CALORIES
# Write-Output "TOP 1 CALORIES : $(($elves.GetEnumerator() | Sort-Object Value | Select-Object -Last 1).Value)"

# # SUM OF TOP 3 CALORIES
# Write-Output "SUM OF TOP 3 CALORIES : $(($elves.GetEnumerator() | Sort-Object Value | Select-Object -Last 3 | Measure-Object Value -Sum).Sum)"
