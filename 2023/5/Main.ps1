[Cmdletbinding()]
Param([string]$InputFile)

function ParseData($data) {
    $allData = @{}
    $stepIndex = 0
    foreach ($line in ($data | Select-Object -Skip 1)) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }

        if ($line.Contains(':')) {
            $stepName = "$stepIndex-$($line.Split(' ')[0].Trim())"
            $allData.Add($stepName, @())
            $stepIndex++
        }
        else {
            $parts = [long[]]$line.split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)
            $allData.$stepName += @{ inStart = $parts[1]; inEnd = $parts[1] + $parts[2] - 1; outStart = $parts[0] ; range = $parts[2] }
        }
    }
    return $allData
}

function ChallengeOne ($data) {
    $seeds = [long[]]$data[0].split(":", [System.StringSplitOptions]::RemoveEmptyEntries)[1].split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)
    $allData = ParseData $data

    $allData.Keys | Sort-Object | ForEach-Object {
        Write-Host "Processing Step: $_ "
        $step = $_
        $newEntries = @()
        $seeds | ForEach-Object {
            $seed = $_
            $newIn = $seed
            foreach ($val in $allData.$step) {
                if ($seed -ge $val.inStart -and $seed -le $val.inEnd) {
                    $newIn = $val.outStart - $val.inStart + $seed
                    break
                }
            }
            $newEntries += $newIn
        }
        $seeds = $newEntries
    }
    Write-Host $seeds
    $minValue = $seeds | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum

    return $minValue
}

function ChallengeTwo ($data) {
    # $seeds = [long[]]$data[0].split(":", [System.StringSplitOptions]::RemoveEmptyEntries)[1].split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)
    $seeds = [System.Collections.ArrayList]@()
    @(280775197..(280775197 + 7535297)).foreach({ $null = $seeds.Add($_) })
    Write-Host "SEEDS POPULATED : $($seeds.Count)"

    $allData = ParseData $data

    $allData.Keys | Sort-Object | ForEach-Object {
        Write-Host "Processing Step: $_ "
        $step = $_
        $newEntries = @()
        # foreach ($seed in $seeds) {
        $seeds.foreach({
                $newIn = $seed
                foreach ($val in $allData.$step) {
                    if ($seed -ge $val.inStart -and $seed -le $val.inEnd) {
                        $newIn = $val.outStart - $val.inStart + $seed
                        break
                    }
                }
                $newEntries += $newIn
                # }
            })
        $seeds = $newEntries
    }
    Write-Host $seeds
    $minValue = $seeds | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum

    return $minValue
}

function Main {
    $inputContent = $(Get-Content $InputFile)

    # Write-Host "Challenge One: $(ChallengeOne $inputContent)"
    Write-Host "Challenge Two: $(ChallengeTwo $inputContent)"
}

Main