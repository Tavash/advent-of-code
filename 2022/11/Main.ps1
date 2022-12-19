[Cmdletbinding()]
Param([string]$InputFile)
$data = Get-Content $InputFile

class Monkey {
    [long]$Id
    [System.Collections.Generic.List[long]]$Items
    [System.Tuple[string, string]]$Operation
    [long]$Test
    [System.Collections.Generic.Dictionary[bool, long]]$TestResult
    [long]$InspectedTimes

    Monkey([long]$id) {
        $this.Id = $id
        $this.Items = [System.Collections.Generic.List[long]]::new()
        $this.TestResult = [System.Collections.Generic.Dictionary[bool, long]]::new()
    }
    [long]GetBoredWorryLevel([long]$modulo) {
        if ($modulo -gt 0) {
            return [Math]::Floor($this.Calculate($this.GetFirstItem()) % $modulo)
        }
        return [Math]::Floor($this.Calculate($this.GetFirstItem()) / 3L)
    }
    AddItem($item) {
        $this.Items.Add($item)
    }
    [bool]HasItems() {
        return $this.Items.Count -gt 0
    }
    [long]RemoveItem() {
        $value = $this.Items[0]
        $this.Items.RemoveAt(0)
        return $value
    }
    [long]GetFirstItem() {
        return $this.Items[0]
    }
    [long]Calculate([long]$item) {
        if ($this.Operation.Item2 -eq "old") { $tmp = [long]::Parse($item) }
        else { $tmp = $this.Operation.Item2 }
        switch ($this.Operation.Item1) {
            "+" { return $item + $tmp }
            "-" { return $item - $tmp }
            "*" { return $item * $tmp }
            "/" { if ($tmp -gt 0) { return ($item / $tmp) } return 0 }
        }
        return 0
    }
    [bool]IsDivisible([long]$modulo) {
        return ($this.GetBoredWorryLevel([long]$modulo) / $this.Test) -is [long]
    }
}

$monkeys = [System.Collections.Generic.Dictionary[long, Monkey]]::new()

foreach ($line in $data) {
    if ($line) {
        if (([string]$line).StartsWith("Monkey")) {
            $splitted = $line -split " "
            $monk = [Monkey]::new([long]$splitted[1].Trim().Replace(":", ""))
            $monkeys.Add($monk.Id, $monk)
        }
        $splitted = $line -split ":"
        if (([string]$line).Trim().StartsWith("Starting items")) {
            $items = $($splitted[1] -split ",").Trim()
            # [array]::Reverse($items)
            foreach ($cur in $items) {
                $monk.AddItem($cur)
            }
        }
        if (([string]$line).Trim().StartsWith("Operation")) {
            $operationSplitted = $splitted[1].Trim() -split " "
            $monk.Operation = [System.Tuple]::Create($operationSplitted[$operationSplitted.Count - 2], $operationSplitted[$operationSplitted.Count - 1])
        }
        if (([string]$line).Trim().StartsWith("Test")) {
            $testSplitted = $splitted[1].Trim() -split " "
            $monk.Test = $testSplitted[$testSplitted.Count - 1]
        }
        if (([string]$line).Trim().StartsWith("If ")) {
            $testResultSplitted = $splitted[1].Trim() -split " "
            $monk.TestResult.Add([bool]::Parse(($splitted[0].Trim() -split " ")[1]), $testResultSplitted[$testResultSplitted.Count - 1])
        }
    }
}

# for ($i = 0; $i -lt 20; $i++) {
#     foreach ($key in $monkeys.Keys) {
#         $m = $monkeys[$key]

#         while ($m.HasItems()) {
#             $m.InspectedTimes++
#             $boredLevel = $m.GetBoredWorryLevel()
#             $res = $m.IsDivisible()
#             $monkeys[$m.TestResult[$res]].AddItem($boredLevel)
#             $m.RemoveItem() | Out-Null
#         }
#     }
# }


# $mostInspected = ($monkeys.Values | Sort-Object InspectedTimes | Select-Object -Last 2)

# $monkeyBiz = $mostInspected[0].InspectedTimes * $mostInspected[1].InspectedTimes
# Write-Host "MONKEY BIZ : $monkeyBiz"
$modulo = 1
$monkeys.Values | ForEach-Object { $modulo *= $_.Test }

for ($i = 0; $i -lt 10000; $i++) {
    foreach ($key in $monkeys.Keys) {
        $m = $monkeys[$key]

        while ($m.HasItems()) {
            $m.InspectedTimes++
            $boredLevel = $m.GetBoredWorryLevel($modulo)
            $res = $m.IsDivisible($modulo)
            $monkeys[$m.TestResult[$res]].AddItem($boredLevel)
            $m.RemoveItem() | Out-Null
        }
    }
}
$mostInspected = ($monkeys.Values | Sort-Object InspectedTimes | Select-Object -Last 2)

$monkeyBiz = $mostInspected[0].InspectedTimes * $mostInspected[1].InspectedTimes
Write-Host "MONKEY BIZ : $monkeyBiz"

$monkeys.Values | Select-Object Id, InspectedTimes