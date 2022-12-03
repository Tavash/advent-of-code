[Cmdletbinding()]
Param([string]$InputFile)
$data = Get-Content $InputFile

$result = @{}
$count = 1

foreach ($line in $data) {
    if ($line) {
        $countChar = ($line | Measure-Object -Character).Characters
        $countHalf = [int]($countChar / 2)
        $firstHalf = $line.Substring(0, $countHalf)
        $secondHalf = $line.Substring($countHalf, $countHalf)

        $tmpList = [System.Collections.ArrayList]::new()
        for ($i = 0; $i -lt $countHalf; $i++) {
            $charTmp = $firstHalf.Substring($i, 1)

            if ([regex]::match($secondHalf, $charTmp).Success) {
                $tmpList.Add($charTmp) | Out-Null
            }
        }
        $result.Add($count, @($tmpList | Get-Unique))
        $count++
    }
}

$total = 0
foreach ($h in $result.GetEnumerator() ) {
    foreach ($val in $h.Value) {
        if ($val -cmatch "^[a-z]*$") {
            $total += ([int]([char]$val) - 96)
        }
        else {
            $total += ([int]([char]$val) - 38)
        }
    }
}

Write-Output "TOTAL : $total"
