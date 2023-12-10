[Cmdletbinding()]
Param([string]$InputFile)

function ProcessData ($data) {
    $stories = @{}

    $i = 1
    foreach ($line in $data) {
        $story = [long[]]$line.Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)
        $stories.Add($i++, @{ story = $story; lastElements = @(); firstElements = @() })
    }

    $stories.Keys | Sort-Object | ForEach-Object {
        $cur = $_
        $allZeros = $false
        $sequences = @{}
        $i = 1
        $nextStory = $stories[$cur].story
        $sequences.Add($i, $nextStory)
        while (!$allZeros) {
            $nextStory = GetNextSequence $nextStory
            if ($nextStory | Group-Object | Where-Object { $_.Count -eq $nextStory.Count -and $_.Name -eq 0 }) {
                $allZeros = $true
            }
            $sequences.Add(++$i, $nextStory)
        }

        $sequences.Keys | ForEach-Object {
            $stories[$cur].lastElements += $sequences[$_] | Select-Object -Last 1
            $stories[$cur].firstElements += $sequences[$_] | Select-Object -First 1
        }
    }

    $passed = @()
    $stories.Keys | ForEach-Object {
        $current = 0
        $allPassed = @($current)

        for ($i = 0; $i -lt $stories[$_].firstElements.Count - 1; $i++) {
            $current = $stories[$_].firstElements[$i + 1] - $current
            $allPassed += $current
        }
        $passed += ($allPassed | Select-Object -Last 1)
    }

    $future = @()
    $stories.Keys | ForEach-Object {
        $current = 0
        $allFutures = @($current)
        for ($i = 0; $i -lt $stories[$_].lastElements.Count - 1; $i++) {
            $current = $stories[$_].lastElements[$i + 1] + $current
            $allFutures += $current
        }
        $future += ($allFutures | Select-Object -Last 1)
    }

    return @{ c1 = $($future | Measure-Object -Sum).Sum; c2 = $($passed | Measure-Object -Sum).Sum }
}

function GetNextSequence ($sequence) {
    $result = @()
    for ($i = 0; $i -lt $sequence.Length - 1; $i++) {
        $result += $sequence[$i + 1] - $sequence[$i]
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
