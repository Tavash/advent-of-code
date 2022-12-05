[Cmdletbinding()]
Param([string]$InputFile)
$data = Get-Content $InputFile

$crateStackLines = [System.Collections.Generic.List[string]]::new()
$stacks = @{}
$moves = @{}
$CRATE_SIZE = 3

$readMoves = $false
$count = 0
foreach ($line in $data) {
    if ($line) {
        if (!$readMoves) { $crateStackLines.Add($line) }
        else {
            $splitted = $line -split " "
            $moves.Add($count, @{ Qty = $splitted[1]; From = $splitted[3]; To = $splitted[5] })
            $count++
        }
    }
    else { $readMoves = $true }
}

function Build() {
    [int]$max = $($crateStackLines[$crateStackLines.Count - 1] -split "  ").Count
    $allLines = $($crateStackLines | Select-Object -SkipLast 1)

    # INIT STACKS
    for ($j = 1; $j -le $max; $j++) {
        $stacks.Add($j, [System.Collections.Generic.Stack[string]]::new())
    }

    # FILL STACKS
    for ($i = ($allLines.Count - 1); $i -ge 0; $i--) {
        $line = $allLines[$i]
        for ($j = 0; $j -lt $max; $j++) {
            if ($j -eq 0) {
                if (![string]::IsNullOrWhiteSpace($line.Substring($j, $CRATE_SIZE))) {
                    $stacks[$j + 1].Push($line.Substring($j, $CRATE_SIZE))
                }
            }
            else {
                $index = ($j * $CRATE_SIZE) + $j
                if ($index -lt $line.Length) {
                    if (![string]::IsNullOrWhiteSpace($line.Substring($index, $CRATE_SIZE))) {
                        $stacks[$j + 1].Push($line.Substring($index, $CRATE_SIZE))
                    }
                }
            }
        }
    }
}

function ApplyMoves1() {
    # APPLY MOVES
    for ($i = 0; $i -lt $moves.Count; $i++) {
        $from = [System.Collections.Generic.Stack[string]]$stacks[[int]$moves.$i.From]
        $to = [System.Collections.Generic.Stack[string]]$stacks[[int]$moves.$i.To]

        for ($j = 0; $j -lt $moves.$i.Qty; $j++) {
            $peek = ""
            if ($from.TryPeek([ref] $peek)) {
                $to.Push($from.Pop())
            }
        }
    }
}

function ApplyMoves2() {
    # APPLY MOVES
    for ($i = 0; $i -lt $moves.Count; $i++) {
        $from = [System.Collections.Generic.Stack[string]]$stacks[[int]$moves.$i.From]
        $to = [System.Collections.Generic.Stack[string]]$stacks[[int]$moves.$i.To]

        $tmpStack = [System.Collections.Generic.Stack[string]]::new()
        for ($j = 0; $j -lt $moves.$i.Qty; $j++) {
            $peek = ""
            if ($from.TryPop([ref] $peek)) {
                $tmpStack.Push($peek)
            }
        }
        $tmpStackCount = $tmpStack.Count
        for ($k = 0; $k -lt $tmpStackCount; $k++) {
            $to.Push($tmpStack.Pop())
        }
    }
}

Build
# ApplyMoves1
ApplyMoves2

$stacks.GetEnumerator() | ForEach-Object {
    $peek = ""
    if ($_.Value.TryPeek([ref] $peek)) {
        $top += $peek.Replace("[", "").Replace("]", "")
    }
}

$top = $top.ToCharArray()
[array]::Reverse($top) | Out-Null

Write-Host "TOP OF EACH CRATES : $($top -join '')"

