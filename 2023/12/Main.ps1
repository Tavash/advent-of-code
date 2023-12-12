[Cmdletbinding()]
Param([string]$InputFile)

[regex]$script:UNKNOWN = "\?"

function ProcessData ($data) {
    $mapC1 = @()
    $mapC2 = @()
    foreach ($line in $data) {
        $rowplit = $line -split ' '
        $row = $rowplit[0]
        $group = [int[]]($rowplit[1] -split ',')
        $mapC1 += [PSCustomObject]@{
            Row     = $row
            Records = $group
        }
        $mapC2 += [PSCustomObject]@{
            Row     = $(@($row) * 5) -join '?'
            Records = $group * 5
        }
    }

    $c1 = 0
    foreach ($m in $mapC1) {
        $c1 += GetArrangements -row $m.Row -group $m.Records
    }

    $c2 = 0
    foreach ($m in $mapC2) {
        $c2 += GetArrangements -row $m.Row -group $m.Records
    }

    return @{ c1 = $c1; c2 = $c2 }
}

function GetArrangements {
    param ([string]$row, [int[]]$group)
    # supprime les '.' au début de la ligne
    $row = $row.TrimStart('.')
    # '', ()
    # '', (1,)
    # combinaison trouvée si group est vide et row est vide
    if ([string]::IsNullOrEmpty($row)) {
        if ($group.Count -eq 0) { return 1 }
        return 0
    }

    # combinaison trouvée si group est vide et row ne contient pas de '#'
    if ($group.Count -eq 0) {
        if ($row -notmatch '#') { return 1 }
        return 0
    }

    # row commence par '#'
    if ($row[0] -eq '#') {
        $current_group = $group[0]

        # ex: "##" (4,) => impossible
        if ($row.Length -lt $current_group) {
            return 0
        }

        # ex: "##.???" (3,1)
        if ($row.Substring(0, $current_group) -match '\.') {
            return 0
        }

        # combinaison trouvée si taille row == group[0] et group n'a qu'un élément
        if ($row.Length -eq $current_group) {
            if ($group.Count -eq 1) {
                return 1
            }
            return 0
        }

        # la séparation d'un spring doit être par un '.' ou '?'
        if ($row[$current_group] -eq '#') {
            return 0
        }

        # sinon on continue avec le reste de la ligne et le reste du group
        return (GetArrangements -row $row.Substring($current_group + 1) -group $group[1..($group.Count)])
    }

    # commence forcément par un '?'
    # si "?###?" (4,) alors
    #   -> "####?" (4,)
    #   -> ".###?" (4,)
    return (GetArrangements -row $UNKNOWN.Replace($row, '#', 1) -group $group) + (GetArrangements -row $row.Substring(1) -group $group)
}

function Main {
    $data = $(Get-Content $InputFile)

    $result = ProcessData $data

    Write-Host "Challenge One: $($result.c1)"
    Write-Host "Challenge Two: $($result.c2)"
}

Main
