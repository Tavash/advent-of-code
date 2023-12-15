[Cmdletbinding()]
Param([string]$InputFile)


$CONFIG = @{ red = 12; green = 13; blue = 14; }

function ProcessFile($data) {
    $result = @()

    foreach ($line in $data) {
        $result += ProcessLine $line
    }

    return $result
}

function ProcessLine($line) {
    $gameId = $line.Split(":")[0].Split(" ")[1]
    $sets = $line.Split(":")[1].Split(";")
    $tmp = @{ id = $gameId; red = 0; green = 0; blue = 0; }

    foreach ($set in $sets) {
        $colors = $set.Split(",")

        foreach ($color in $colors) {
            $color = $color.Trim()
            $colorName = $color.Split(" ")[1]
            $colorCount = [int]$color.Split(" ")[0]

            if ($colorCount -gt $tmp[$colorName]) {
                $tmp[$colorName] = $colorCount
            }
        }
    }

    return $tmp
}


function Main {
    $result = ProcessFile $(Get-Content $InputFile)

    $sum1 = 0
    $sum2 = 0
    $result | ForEach-Object {
        if ($_.red -le $CONFIG.red -and $_.green -le $CONFIG.green -and $_.blue -le $CONFIG.blue) {
            $sum1 += $_.id
        }
        $sum2 += ($_.red * $_.green * $_.blue)
    }
    Write-Host "Challenge 1: $sum1"
    Write-Host "Challenge 2: $sum2"
}

Main

