[Cmdletbinding()]
Param([string]$InputFile)

function ProcessData ($data) {
    $result = @{}
    $copies = @{}
    foreach ($line in $data) {
        $split1 = $line.Split(':', [System.StringSplitOptions]::RemoveEmptyEntries)
        $split2 = $split1[1].Split('|', [System.StringSplitOptions]::RemoveEmptyEntries)
        $winning = [int[]]$split2[0].Trim().Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)
        $draw = [int[]]$split2[1].Trim().Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)
        $res = @{ Id = [int]$split1.Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)[1]; Matched = 0; Score = 0; Copies = @(); }

        foreach ($n in $draw) { if ($winning -contains $n) { $res.Matched += 1 } }
        if ($res.Matched -ge 1) {
            $res.Score = [math]::Pow(2, $res.Matched - 1)
            $res.Copies += ($res.Id + 1)..($res.Id + $res.Matched)
        }
        $copies.Add($res.Id, 1)
        $result.Add($res.Id, $res)
    }
    $result.Keys | Sort-Object | ForEach-Object {
        for ($i = $_ + 1; $i -le ($_ + $result.$_.Copies.Count); $i++) {
            $copies.$i += $copies.$_
        }
    }

    return @{ c1 = $result; c2 = $copies; }
}

function Main {
    $result = ProcessData $(Get-Content $InputFile)
    $challengeOne = 0
    $result.c1.Keys | ForEach-Object { $challengeOne += $result.c1.$_.Score }

    $challengeTwo = 0
    $result.c2.Keys | ForEach-Object { $challengeTwo += $result.c2.$_ }

    Write-Host "Challenge One: $challengeOne"
    Write-Host "Challenge Two: $challengeTwo"
}

Main
