[Cmdletbinding()]
Param([string]$InputFile)
$data = Get-Content $InputFile


function GetTotalStrength() {
    $register = 1
    $cycles = @{}
    $cycle = 0

    for ($index = 0; $index -le $data.Count; $index++) {
        $line = $data[$index]
        if ($line) {
            $splitted = $line -split " "
            if ($line -eq "noop") {
                $cycle++
                $cycles.Add($cycle, $register)
            }
            elseif ($splitted[0] -eq "addx") {
                $cycle++
                $cycles.Add($cycle, $register)
                $cycle++
                $cycles.Add($cycle, $register)
                $register += $splitted[1]
            }
        }
    }
    $totalStrength = $(@(20, 60, 100, 140, 180, 220) | ForEach-Object { return $cycles.$_ * $_ } | Measure-Object -Sum).Sum
    return $totalStrength
}

function GetPixel([int]$curPos, [int]$register) {
    if (@(($register - 1), $register, ($register + 1)) -contains $curPos) { return "#" }
    return "."
}

function GetDrawing() {
    $register = 1
    $cycle = 0
    $drawing = [System.Collections.Generic.List[string]]::new()

    for ($index = 0; $index -le $data.Count; $index++) {
        $line = $data[$index]
        if ($line) {
            $splitted = $line -split " "
            if ($line -eq "noop") {
                $cycle++
                $curPos = $cycle % 40
                $currentLine += GetPixel ($curPos-1) $register
                if ($curPos -eq 0) {
                    $drawing.Add($currentLine)
                    $currentLine = ""
                }
            }
            elseif ($splitted[0] -eq "addx") {
                $cycle++
                $curPos = $cycle % 40
                $currentLine += GetPixel ($curPos-1) $register
                if ($curPos -eq 0) {
                    $drawing.Add($currentLine)
                    $currentLine = ""
                }
                $cycle++
                $curPos = $cycle % 40
                $currentLine += GetPixel ($curPos-1) $register
                if ($curPos -eq 0) {
                    $drawing.Add($currentLine)
                    $currentLine = ""
                }
                $register += $splitted[1]
            }
        }
    }
    return $drawing
}

Write-Host "TOTAL STRENGTH : $(GetTotalStrength)"

GetDrawing