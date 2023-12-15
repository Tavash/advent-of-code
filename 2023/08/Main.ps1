[Cmdletbinding()]
Param([string]$InputFile)

function ProcessData ($data) {
    $tree = @{}
    $insctructions = $data[0].ToCharArray()

    foreach ($line in $data | Select-Object -Skip 1) {
        if (-not [string]::IsNullOrWhiteSpace($line)) {
            $parts = $line -split ' = \('
            $parent = $parts[0].Trim()
            $children = $parts[1].Trim(')').Split(',').Trim()
            $tree[$parent] = $children
        }
    }
    return @{ tree = $tree; insctructions = $insctructions }
}

function LeastCommonMultiple($a, $b) {
    $a1 = $a
    $b1 = $b
    while ($b1 -ne 0) {
        $temp = $b1
        $b1 = $a1 % $b1
        $a1 = $temp
    }
    return [Math]::Abs($a * $b) / $a1
}

function ChallengeOne ($tree, $insctructions) {
    $count = 0
    $leaf = 'AAA'
    while ($leaf -ne 'ZZZ') {
        foreach ($instruction in $insctructions) {
            if ($instruction -eq 'L') { $leaf = $tree[$leaf][0] }
            else { $leaf = $tree[$leaf][1] }
            $count++
        }
    }

    return $count
}

function ChallengeTwo ($tree, $insctructions) {
    $leaves = $tree.Keys | Where-Object { $_.EndsWith('A') }

    $allCounts = @()
    foreach ($leaf in $leaves) {
        $count = 0
        while ($leaf.EndsWith('Z') -eq $false) {
            foreach ($instruction in $insctructions) {
                if ($instruction -eq 'L') { $leaf = $tree[$leaf][0] }
                else { $leaf = $tree[$leaf][1] }
                $count++
            }
        }
        $allCounts += $count
    }

    $result = $allCounts[0]
    foreach ($c in $allCounts) { $result = LeastCommonMultiple $result $c }

    return $result
}

function Main {
    $data = $(Get-Content $InputFile)

    $parsedData = ProcessData $data

    Write-Host "Challenge One: $(ChallengeOne $parsedData.tree $parsedData.insctructions)"
    Write-Host "Challenge Two: $(ChallengeTwo $parsedData.tree $parsedData.insctructions)"
}

Main
