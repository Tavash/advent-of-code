[Cmdletbinding()]
Param([string]$InputFile)
$data = Get-Content $InputFile

class Item {
    [string]$Name
    [string]$Type
    [string]$Fullpath
    [Item]$Parent
    [System.Collections.Generic.List[Item]]$Children
    [Int]$Size
    [Int]$TotalSize

    Item([string]$name, [string]$type, [Item]$parent = $null, [Int]$size = 0) {
        $this.Name = $name
        $this.Type = $type
        $this.Parent = $parent
        $this.Children = [System.Collections.Generic.List[Item]]::new()
        $this.Size = $size
        if ($parent) {
            $this.FullPath = "$($parent.FullPath)/$name"
        }
    }

    [string]GetFullPath() {
        if ($this.Parent) {
            $this.FullPath = "$($this.Parent.FullPath)/$($this.Name)"
            return $this.Fullpath
        }
        return ""
    }

    [Int]GetTotalSize() {
        if ($this.Type -eq "file") {
            $this.TotalSize = $this.Size
            return $this.TotalSize
        }
        else {
            $total = 0
            $this.Children | ForEach-Object { $total += $_.GetTotalSize() }
            $this.TotalSize = $total
            return $this.TotalSize
        }
    }
}

$dico = [System.Collections.Generic.Dictionary[string, Item]]::new()
$dico.Add("/", [Item]::new("/", "dir", $null, 0))

foreach ($line in $data) {
    if ($line) {
        $splitted = $line -split " "
        if ($splitted[0] -eq "$" -and $splitted[1] -eq "cd") {
            if ($splitted[2] -eq "/") { $current = $dico["/"] }
            elseif ($splitted[2] -eq "..") {
                if ($current.Parent) { $current = $current.Parent }
                else { $current = $dico["/"] }
            }
            else { $current = $dico["$($current.GetFullPath())/$($splitted[2])"] }
        }
        elseif ($splitted[0] -match "^[0-9]") { $current.Children.Add([Item]::new($splitted[1], "file", $current, [Int]$splitted[0])) }
        elseif ($splitted[0] -eq "dir") {
            [Item]$newDir = [Item]::new($splitted[1], "dir", $current, 0)
            if (!$dico.Keys.Contains($newDir.GetFullPath())) {
                $current.Children.Add($newDir)
                $dico.Add($newDir.GetFullPath(), $newDir)
            }
        }
    }
}

Write-Host "1) TOTAL SIZE : $(($dico.Values | Where-Object { $_.GetTotalSize() -le 100000 } | Measure-Object TotalSize -Sum).Sum)"

$TOTAL_DISK_SIZE = 70000000
$unUsedSpace = $TOTAL_DISK_SIZE - $dico["/"].GetTotalSize()

Write-Host "2) TOTAL SIZE : $(($dico.Values | Where-Object { $_.Name -ne "/" -and ($_.GetTotalSize() + $unUsedSpace) -ge 30000000 } | Sort-Object TotalSize | Select-Object -First 1).TotalSize)"
