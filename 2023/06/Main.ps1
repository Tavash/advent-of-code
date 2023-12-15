[Cmdletbinding()]
Param([string]$InputFile)

function ProcessData ($times, $distances) {
    $races = @{}
    for ($i = 0; $i -lt $times.Length; $i++) { $races.Add($i, @{ time = $times[$i]; distance = $distances[$i] }) }

    $result = @{}
    $races.Keys | ForEach-Object {
        $beatRecordCount = 0
        for ($i = 0; $i -lt $races.$_.time; $i++) {
            if (($races.$_.time - $i) * $i -gt $races.$_.distance) { $beatRecordCount++ }
        }
        $result.Add($_, $beatRecordCount)
    }

    return $result
}

function Main {
    $data = $(Get-Content $InputFile)

    $times = [bigint[]]$data[0].split(":", [System.StringSplitOptions]::RemoveEmptyEntries)[1].split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)
    $distances = [bigint[]]$data[1].split(":", [System.StringSplitOptions]::RemoveEmptyEntries)[1].split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)
    $times2 = [bigint]$data[0].split(":")[1].Replace(" ", "")
    $distances2 = [bigint]$data[1].split(":")[1].Replace(" ", "")

    $result = ProcessData $times $distances
    $challengeOne = 1
    $result.Keys | ForEach-Object { $challengeOne *= $result.$_ }
    Write-Host "Challenge One: $challengeOne"

    $result = ProcessData $times2 $distances2
    $challengeTwo = 1
    $result.Keys | ForEach-Object { $challengeTwo *= $result.$_ }
    Write-Host "Challenge Two: $challengeTwo"
}

Main
