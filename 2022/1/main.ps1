[Cmdletbinding()]
Param([string]$InputFile)

$elves = @{}
$tempSum = 0
$elfCounter = 1
$count = 0

$data = Get-Content $InputFile
$totalLines = ($data | Measure-Object).Count

foreach ($line in $data) {
    $count++
    if ($line) { $tempSum += [int]$line }

    if (!$line -or ($totalLines -eq $count)) {
        $elves.Add($elfCounter, $tempSum)
        $elfCounter++
        $tempSum = 0
    }
}

# TOP 1 CALORIES
Write-Output "TOP 1 CALORIES : $(($elves.GetEnumerator() | Sort-Object Value | Select-Object -Last 1).Value)"

# SUM OF TOP 3 CALORIES
Write-Output "SUM OF TOP 3 CALORIES : $(($elves.GetEnumerator() | Sort-Object Value | Select-Object -Last 3 | Measure-Object Value -Sum).Sum)"
