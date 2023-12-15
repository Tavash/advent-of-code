[Cmdletbinding()]
Param([string]$InputFile)

$conversion = @{ "A" = "A"; "K" = "B"; "Q" = "C"; "J" = "D"; "T" = "E"; "9" = "F"; "8" = "G"; "7" = "H"; "6" = "I"; "5" = "J"; "4" = "K"; "3" = "L"; "2" = "M"; }
$conversion2 = @{ "A" = "A"; "K" = "B"; "Q" = "C"; "T" = "D"; "9" = "E"; "8" = "F"; "7" = "G"; "6" = "H"; "5" = "I"; "4" = "J"; "3" = "K"; "2" = "L"; "J" = "M" }
$combinations = @{ FiveOfAKind = 7; FourOfAKind = 6; FullHouse = 5; ThreeOfAKind = 4; TwoPairs = 3; Pair = 2; HighCard = 1; }

function ProcessData ($data) {
    $table = @{}
    $i = 1
    foreach ($line in $data) {
        $parts = $line.Split(' ')
        $hand = $parts[0]
        $handValue = ""
        $hand.ToCharArray() | ForEach-Object { $handValue += $conversion["$_"] }
        $handValueWithJoker = ""
        $hand.ToCharArray() | ForEach-Object { $handValueWithJoker += $conversion2["$_"] }
        $table.Add($i, @{ id = $i; hand = $hand; bid = [int]$parts[1]; combination = $(GetHandCombination $hand); handValue = $handValue; combinationWithJoker = $(GetHandCombinationWithJoker $hand); handValueWithJoker = $handValueWithJoker; })
        $i++
    }

    $groupedTable = $table.Values | Sort-Object -Property combination -Descending | Group-Object -Property combination
    $rank = 0
    foreach ($group in $groupedTable) {
        # Write-Host "Processing Group: $($group.Name)"
        $orderedGroup = $group.Group | Sort-Object -Property handValue -Descending
        foreach ($item in $orderedGroup) {
            $table.$($item.id).rank = ++$rank
            # Write-Host "Processing Item: $($item.hand) | HANDVALUE: $($item.handValue) | COMBINATION: $($item.combination) | RANK: $($item.rank) | BID: $($item.bid)"
        }
    }
    $groupedTable = $table.Values | Sort-Object -Property combinationWithJoker -Descending | Group-Object -Property combinationWithJoker
    $rank = 0
    foreach ($group in $groupedTable) {
        # Write-Host "Processing Group: $($group.Name)"
        $orderedGroup = $group.Group | Sort-Object -Property handValueWithJoker -Descending
        foreach ($item in $orderedGroup) {
            $table.$($item.id).rankWithJoker = ++$rank
            # Write-Host "Processing Item: $($item.hand) | HANDVALUEWITHJOKER: $($item.handValueWithJoker) | COMBINATIONWITHJOKER: $($item.combinationWithJoker) | RANK: $($item.rankWithJoker) | BID: $($item.bid)"
        }
    }

    return $table
}

function GetHandCombination ($hand) {
    $splittedHand = $hand.ToCharArray()
    $groupedHand = $splittedHand | Group-Object -Property { $_ }

    # Check if hand is FiveOfAKind
    $value = $groupedHand | Where-Object { $_.Count -eq 5 } | ForEach-Object { return $combinations.FiveOfAKind }
    # Check if hand is FourOfAKind
    if ($null -eq $value) {
        $value = $groupedHand | Where-Object { $_.Count -eq 4 } | ForEach-Object { return $combinations.FourOfAKind }
    }
    # Check if hand is FullHouse or ThreeOfAKind
    if ($null -eq $value) {
        $hasThreeOfAKind = $groupedHand | Where-Object { $_.Count -eq 3 } | ForEach-Object { return $combinations.ThreeOfAKind }
        $hasPair = $groupedHand | Where-Object { $_.Count -eq 2 } | ForEach-Object { return $combinations.Pair }
        if ($null -ne $hasThreeOfAKind -and $null -ne $hasPair) { $value = $combinations.FullHouse }
        elseif ($null -ne $hasThreeOfAKind) { $value = $combinations.ThreeOfAKind }
    }
    # Check if hand is TwoPairs
    if ($null -eq $value) {
        if (@($groupedHand | Where-Object { $_.Count -eq 2 }).Count -eq 2) { $value = $combinations.TwoPairs }
    }
    # Check if hand is Pair
    if ($null -eq $value) {
        $value = $groupedHand | Where-Object { $_.Count -eq 2 } | ForEach-Object { return $combinations.Pair }
    }
    # Check if hand is HighCard
    if ($null -eq $value) { $value = $combinations.HighCard }
    return $value
}

function GetHandCombinationWithJoker ($hand) {
    $value = GetHandCombination $hand
    $joker = "J"

    if ($value -eq $combinations.FiveOfAKind) { return $value }

    $splittedHand = $hand.ToCharArray()
    $groupedHand = $splittedHand | Group-Object -Property { $_ }
    $hasJoker = $groupedHand | Where-Object { $_.Name -eq $joker } | ForEach-Object { return $true }

    # Check if hand is FiveOfAKind with Joker 'J'
    if ($value -eq $combinations.FourOfAKind) {
        if ($hasJoker) { return $combinations.FiveOfAKind }
        return $value
    }
    # Check if FullHouse with Joker 'J' can be FiveOfAKind
    if ($value -eq $combinations.FullHouse) {
        if ($hasJoker) { return $combinations.FiveOfAKind }
        return $value
    }
    # Check if hand is FourOfAKind with Joker 'J'
    if ($value -eq $combinations.ThreeOfAKind) {
        if ($hasJoker) { return $combinations.FourOfAKind }
        return $value
    }
    # Check if TwoPairs is FourOfAKind with Joker 'J'
    if ($value -eq $combinations.TwoPairs) {
        $hasOneJoker = $groupedHand | Where-Object { $_.Count -eq 1 -and $_.Name -eq $joker } | ForEach-Object { return $true }
        if ($hasOneJoker) { return $combinations.FullHouse }
        $hasTwoJokers = $groupedHand | Where-Object { $_.Count -eq 2 -and $_.Name -eq $joker } | ForEach-Object { return $true }
        if ($hasTwoJokers) { return $combinations.FourOfAKind }
        return $value
    }
    # Check if Pair is ThreeOfAKind with Joker 'J'
    if ($value -eq $combinations.Pair) {
        if ($hasJoker) { return $combinations.ThreeOfAKind }
        return $value
    }
    # Check if HighCard is Pair with Joker 'J'
    if ($value -eq $combinations.HighCard) {
        if ($hasJoker) { return $combinations.Pair }
        return $value
    }
    return $value
}

function Main {
    $data = $(Get-Content $InputFile)

    $table = ProcessData $data

    [long]$challengeOne = 0
    [long]$challengeTwo = 0
    $table.Keys | ForEach-Object {
        $challengeOne += $table.$_.bid * $table.$_.rank
        $challengeTwo += $table.$_.bid * $table.$_.rankWithJoker
    }

    Write-Host "Challenge One: $challengeOne"
    Write-Host "Challenge Two: $challengeTwo"
}

Main
