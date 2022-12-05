
# To run unit tests, executes the command :
#    Invoke-Pester -Output Detailed ./Main.Tests.ps1
BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
    $sample = "$PSScriptRoot/sample.txt"
}

Describe "Day1" {
    Context "sample.txt" {

        It "Get Top 1 = 24000" {
            # Arrange
            $data = ProcessFile $(Get-Content $sample)

            # Act
            $result = GetTopOne $data

            # Assert
            $result | Should -BeExactly 24000
        }
        It "Get Top 3 sum = 45000" {
            # Arrange
            $data = ProcessFile $(Get-Content $sample)

            # Act
            $result = GetTopThree $data

            # Assert
            $result | Should -BeExactly 45000
        }
    }
}
