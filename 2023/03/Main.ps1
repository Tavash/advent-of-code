[Cmdletbinding()]
Param([string]$InputFile)

function ProcessData ($data) {
    $numbers = @()
    for ($i = 0; $i -lt $data.Length; $i++) {
        $j = 0
        while ($j -lt $data[$i].Length) {
            # If the character is a number
            if ($data[$i][$j] -match '\d') {
                # Get the whole number
                $number = ""
                $startPos = $j
                while ($j -lt $data[$i].Length -and $data[$i][$j] -match '\d') {
                    $number += $data[$i][$j]
                    $j++
                }
                $endPos = $j - 1
                # Check surrounding characters for symbols
                for ($x = [Math]::Max(0, $i - 1); $x -le [Math]::Min($i + 1, $data.Length - 1); $x++) {
                    for ($y = [Math]::Max(0, $startPos - 1); $y -le [Math]::Min($endPos + 1, $data[$i].Length - 1); $y++) {
                        # If the surrounding character is a symbol, save the number
                        if ($symbols -contains $data[$x][$y]) {
                            # Skip if the number is already in the list
                            if ($numbers.Number -ne $number -and $number.Position -ne "$i,$startPos") {
                                $numbers += @{
                                    Number         = [int]$number
                                    Position       = "$i,$startPos"
                                    SymbolPosition = "$x,$y"
                                }
                            }
                            break
                        }
                    }
                }
            }
            else {
                $j++
            }
        }
    }
    return $numbers
}

function Main {
    $symbols = '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+', '[', ']', '{', '}', ';', ':', "'", '"', ',', '<', '>', '/', '\', '|', '?', '~', '`'
    $result = ProcessData $(Get-Content $InputFile)
    $result | ForEach-Object { $c1 += $_.Number }

    $symbols = '*'
    $result = ProcessData $(Get-Content $InputFile)
    $result | Group-Object SymbolPosition | ForEach-Object {
        if ($_.Count -gt 1) {
            $c2 += $_.Group[0].Number * $_.Group[1].Number
        }
    }

    Write-Host "Challenge 1: $c1"
    Write-Host "Challenge 2: $c2"
}

Main
