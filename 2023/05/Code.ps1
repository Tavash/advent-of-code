$lines = Get-Content "input.txt"

$raw_seeds = [long[]]$lines[0].split(":", [System.StringSplitOptions]::RemoveEmptyEntries)[1].split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)
$seeds = for ($i = 0; $i -lt $raw_seeds.Length; $i += 2) {
    , ($raw_seeds[$i], $raw_seeds[$i + 1])
}

$maps = @()
$i = 2
while ($i -lt $lines.Length) {
    $catA, $null, $catB = $lines[$i].Split(" ")[0].Split("-")
    $maps += , @()

    $i++
    while ($i -lt $lines.Length -and $lines[$i] -ne "") {
        $dstStart, $srcStart, $rangeLen = $lines[$i].Split(" ") | ForEach-Object { [long]$_ }
        $maps[-1] += , ($dstStart, $srcStart, $rangeLen)
        $i++
    }

    $maps[-1] = $maps[-1] | Sort-Object @{Expression = { $_[1] }; Ascending = $true }

    $i++
}

foreach ($m in $maps) {
    for ($i = 0; $i -lt $m.Length - 1; $i++) {
        if (-not ($m[$i][1] + $m[$i][2] -le $m[$i + 1][1])) {
            Write-Host "$($m[$i]) $($m[$i+1])"
        }
    }
}

function Remap($lo, $hi, $m) {
    # Remap an interval (lo,hi) to a set of intervals m
    $ans = @()
    foreach ($mapping in $m) {
        $dst, $src, $R = $mapping
        $end = $src + $R - 1
        $D = $dst - $src  # How much is this range shifted

        if (-not ($end -lt $lo -or $src -gt $hi)) {
            $ans += , ($([System.Math]::Max($src, $lo)), $([System.Math]::Min($end, $hi)), $D)
        }
    }

    for ($i = 0; $i -lt $ans.Length; $i++) {
        $l, $r, $D = $ans[$i]
        , (($l + $D), ($r + $D))

        if ($i -lt $ans.Length - 1 -and $ans[$i + 1][0] -gt ($r + 1)) {
            , (($r + 1), ($ans[$i + 1][0] - 1))
        }
    }

    # End and start ranges can use some love
    if ($ans.Length -eq 0) {
        , ($lo, $hi)
        return
    }

    if ($ans[0][0] -ne $lo) {
        , ($lo, ($ans[0][0] - 1))
    }
    if ($ans[-1][1] -ne $hi) {
        , (($ans[-1][1] + 1), $hi)
    }
}

$ans = [math]::Pow(2, 70)

foreach ($item in $seeds) {
    $start, $R = $item
    $cur_intervals = @($start, $($start + $R - 1))

    $new_intervals = @()

    foreach ($m in $maps) {
        foreach ($item in $cur_intervals) {
            $lo, $hi = $item
            foreach ($new_interval in Remap $lo $hi $m) {
                $new_intervals += , $new_interval
            }
        }

        $cur_intervals, $new_intervals = $new_intervals, @()
    }

    foreach ($item in $cur_intervals) {
        $lo, $hi = $item
        $ans = [math]::Min($ans, $lo)
    }
}

Write-Host $ans
