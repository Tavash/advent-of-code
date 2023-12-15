[Cmdletbinding()]
Param([string]$InputFile)

function ProcessFile($data) {
    $sum = 0
    $count = 0
    $result = [System.Collections.Generic.List[int]]::new()
    $totalLines = ($data | Measure-Object).Count

    foreach ($line in $data) {
        $count++
        if ($line) { $sum += [int]$line }
        if (!$line -or ($totalLines -eq $count)) {
            $result.Add($sum)
            $sum = 0
        }
    }
    return $result
}

function GetTopOne($result) {
    return ($result | Sort-Object | Select-Object -Last 1)
}

function GetTopThree($result) {
    return ($result | Sort-Object | Select-Object -Last 3 | Measure-Object -Sum).Sum
}

function Main {
    $result = ProcessFile $(Get-Content $InputFile)

    # TOP 1 CALORIES
    Write-Output "TOP 1 CALORIES : $(GetTopOne $result)"

    # SUM OF TOP 3 CALORIES
    Write-Output "SUM OF TOP 3 CALORIES : $(GetTopThree $result)"
}