[Cmdletbinding()]
Param([string]$InputFile)

$dico = @{
    one   = 1
    two   = 2
    three = 3
    four  = 4
    five  = 5
    six   = 6
    seven = 7
    eight = 8
    nine  = 9
}

$numberWordsRegex = [regex]"(?i)($($dico.Keys -join '|'))"

function ProcessFile($data) {
    $result = @()

    foreach ($line in $data) {
        # Comment next line for challenge 1
        $line = ChallengeTwo $line

        $result += ChallengeOne $line
    }

    return $result
}

function ChallengeOne ($line) {
    $firstNumber = ($line -split '(\d)')[1]
    $lastNumber = ($line -split '(\d)')[-2]
    return "$firstNumber$lastNumber"
}

function ChallengeTwo ($line) {
    $start = 0
    while ($start -lt $line.Length -and $numberWordsRegex.Match($line, $start).Success) {
        $match = $regex.Match($line, $start)
        $line = $line.Insert($match.Index + 1, $dico[$match.Value])
        $start = $match.Index + 1
    }
    return $line
}

function Main {
    $result = ProcessFile $(Get-Content $InputFile)

    Write-Host $($result | Measure-Object -Sum).Sum
}

Main

