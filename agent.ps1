#Requires -Modules Pester

param (
  [Parameter(Mandatory = $false, Position = 0)]
  [string]$target = "100.200.60.200",

  [Parameter(Mandatory = $false, Position = 1)]
  [ValidateSet("webserver", "webpublish", "worker", "master", "enduser", "adminconsole")]
  [String[]]$type = "enduser"
)


#populate vars for testing
switch ($type) {
  "enduser" {$allPorts =  @(80, 443, 2399, 5003); break}
  "adminconsole" {$allPorts = @(80, 16000); break}
  "master" {$allPorts = @(80, 443, 1895, 2399, 5003, 16000, 16001, 16004, 50003, 50004); break}
  "worker" {$allPorts = @(5013, 16000, 16001); break}
  "webpublish" {$allPorts = @(5015, 8998, 9889, 9898, 16020, 16021); break}
  "webserver" {$allPorts = @(80, 443); break}
}

# Pester tests
Describe 'FileMaker 17' {
  Context "Port Connections" {
  
    It "Ping ${target}" {
      (Test-NetConnection $target).PingSucceeded | Should -Be $true
    }

    foreach ($port in $allPorts) {
      It "Connect to port ${port}" {
        (Test-NetConnection $target -port $port).TcpTestSucceeded | Should -Be $true
      }
    }
  }
}