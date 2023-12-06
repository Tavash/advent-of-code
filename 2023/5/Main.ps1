[Cmdletbinding()]
Param([string]$InputFile)

function GetData($data) {
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
            $parts = [bigint[]]$line.split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)
            $allData.$stepName += @{ src = $parts[1]; dest = $parts[0]; range = $parts[2] }
        }
    }

    return $allData
}

function ProcessData ($data) {
    $seeds = [bigint[]]$data[0].split(":", [System.StringSplitOptions]::RemoveEmptyEntries)[1].split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)

    $allData = GetData $data

    [Collections.Generic.Dictionary[bigint, bigint]]$result = @{}
    $seeds | ForEach-Object { $result.Add($_, $_) }

    Write-Host "Seed: $($result.Keys -join ',')"

    [bigint]$seed = 280775197
    $allData.Keys | Sort-Object | ForEach-Object {
        Write-Host "Processing Step: $_ "
        $step = $_
        [Collections.Generic.Dictionary[bigint, bigint]]$pairs = @{}

        $list = $allData.$step | Sort-Object -Property src
        $srcMax = $list | Measure-Object -Maximum -Property src | Select-Object -ExpandProperty Maximum

        for ([bigint]$i = 0; $i -le [bigint]$srcMax; $i = $i + 1) { $pairs.Add($i, $i) }

        foreach ($tmp in $list) {
            Write-Host "$($tmp.src) -> $($tmp.dest) ($($tmp.range))"
            $dest = $tmp.dest
            for ([bigint]$k = [bigint]$tmp.src; $k -le [bigint]($tmp.src + $tmp.range); $k = $k + 1) {
                $pairs[$k] = $dest
                $dest = $dest + 1
            }
        }
        # $pairs.Keys | ForEach-Object { Write-Host "*$_* -> *$($pairs[$_])*" }
        if ($pairs.ContainsKey($seed)) {
            $seed = $pairs[$seed]
        }
        # $result.Keys | ForEach-Object {
        #     if ($pairs.ContainsKey($result.$_)) {
        #         $result.$_ = $pairs[$result.$_]
        #     }
        # }
        Write-Host "$seed"
    }
    Write-Host "Seed: $seed"

    $result.Keys | ForEach-Object {
        Write-Host "$_ -> $($result[$_])"
    }
    $minValue = $result.Values | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum

    Write-Host "Challenge 1: $minValue"
}



function Main {
    $result = ProcessData $(Get-Content $InputFile)

    # Write-Host "Challenge One: $challengeOne"
    # Write-Host "Challenge Two: $challengeTwo"
}

Main

# if ($seed -lt $list[0].src -and $list[0].src -gt 0) {
#     continue
# }
# else {
# for ($i = 0; $i -lt ($list.Count - 1); $i++) {
#     if ($i -le $list.Count) {
#         if ($seed -ge $list[$i].src -and $seed -le $list[$i + 1].src) {

#         }
#     }
#     else {

#     }
# }
# }
